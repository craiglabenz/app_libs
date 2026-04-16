import 'package:example_flutter/core/auth/auth.dart';
import 'package:example_flutter/core/core.dart';
import 'package:example_shared/models.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final _log = Logger('Redirection');

/// Type alias for route parameters.
typedef Params = Map<String, String>;

/// {@template GoRouterRedirector}
/// Validates that the user's current location within the app is allowed by
/// their authentication state and other details like app health.
/// {@endtemplate}
class GoRouterRedirector {
  /// Singleton constructor.
  factory GoRouterRedirector() => const GoRouterRedirector._(
    <Redirector>[
      AuthenticatedUsersAwayFromLogin(),
    ],
    <String>[
      // globalMaintenanceRoute.path
      // globalForceUpgradeRoute.path
    ],
  );

  const GoRouterRedirector._(this._redirects, this._doNotLeave);

  final List<Redirector> _redirects;

  /// Forced dead-end paths that, once routed to, cannot be routed away from by
  /// any other redirect rules; but instead, only by the undoing of the
  /// conditions that led to redirecting here in the first place.
  final List<String> _doNotLeave;

  /// Compares the current [RouteState] against the [AuthState] and returns a
  /// string to navigate to if required. Returns null if the current
  /// [RouteState] and [AuthState] are compatible.
  String? redirect({
    required RouteState routeState,
    required AuthSession? session,
  }) {
    _log.finest(
      'Considering redirect for "${routeState.path}" with user '
      '${session?.authUserId}',
    );
    if (_doNotLeave.contains(routeState.path)) {
      _log.finest(
        'Not navigating away from ${routeState.path} for DO NOT LEAVE',
      );
      return null;
    }
    final current = Uri(
      path: routeState.path,
      queryParameters:
          routeState
              .uri
              .queryParameters
              .isNotEmpty //
          ? routeState.uri.queryParameters
          : null,
    );
    for (final redirect in _redirects) {
      if (redirect.predicate(routeState, session)) {
        final newRouteState = redirect.getNewRouteState(routeState, session);
        final uriString = newRouteState.uri.toString();

        if (uriString == current.toString()) {
          _log.warning(
            '$redirect attempted to redirect to itself at $uriString. '
            'This should have been caught earlier!',
          );
          continue;
        }

        _log.finer('$redirect redirecting from $current to $uriString');
        return uriString;
      } else {
        _log.finest(
          '$redirect declined to redirect away from ${routeState.path}',
        );
      }
    }
    _log.finer('Not redirecting away from ${routeState.path}');
    return null;
  }
}

/// {@template RouteState}
/// Simplified representation of the user's location within the app. Exists to
/// contain an individual routing solution from leaking its logic all across
/// the app's codebase.
/// {@endtemplate}
class RouteState {
  /// Instantiates a new [RouteState].
  const RouteState({
    required this.uri,
    this.route,
  });

  /// Converts a [GoRouterState] object into the values the rest of our app will
  /// care about.
  factory RouteState.fromGoRouterState(GoRouterState state) {
    assert(
      state.fullPath != null,
      'Unexpectedly had null [GoRouterState.fullPath]',
    );
    return RouteState(
      uri: state.uri,
      route: state.topRoute,
    );
  }

  /// Builds a GoRouterState value from a given route.
  /// Useful for the initial route.
  factory RouteState.fromRoute(GoRoute route, {Params? pathParameters}) {
    String path = route.path;
    if (pathParameters != null) {
      for (final key in pathParameters.keys) {
        path = path.replaceAll(':$key', pathParameters[key]!);
      }
    }
    return RouteState(
      uri: Uri(path: path),
      route: route,
    );
  }

  /// Fully formed URI of the route.
  final Uri uri;

  /// The [GoRoute] that matches the current URI.
  final GoRoute? route;

  /// Path of the route.
  String get path => uri.path;

  @override
  String toString() => 'RouteState(uri: $uri, route.path: ${route?.path})';
}

/// Individual utility within a [GoRouterRedirector] to enforce a single rule.
abstract class Redirector {
  /// Const constructor.
  const Redirector();

  /// Determines whether this redirection should take place.
  bool predicate(RouteState routeState, AuthSession? session);

  /// Returns the desired [Uri] to send the user based on current app state.
  RouteState getNewRouteState(RouteState routeState, AuthSession? session);

  @override
  String toString() => '$runtimeType()';
}

/// {@template AuthenticatedUsersAwayFromLogin}
/// Sends authenticated users away from the login screen.
/// {@endtemplate}
class AuthenticatedUsersAwayFromLogin extends Redirector {
  /// {@macro AuthenticatedUsersAwayFromLogin}
  const AuthenticatedUsersAwayFromLogin();
  @override
  bool predicate(
    RouteState routeState,
    AuthSession? session,
  ) => routeState.path == AppRoutes.loginRoute.path && session != null;

  @override
  RouteState getNewRouteState(
    RouteState routeState,
    AuthSession? session,
  ) => RouteState.fromRoute(AppRoutes.homeRoute);
}
