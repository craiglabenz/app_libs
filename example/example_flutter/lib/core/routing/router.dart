import 'dart:async';

import 'package:example_flutter/core/auth/auth.dart';
import 'package:example_flutter/core/core.dart';
import 'package:example_shared/models.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

final _log = Logger('AppRouter');

/// [GoRouter] wrapper with logging and redirection logic.
class AppRouter {
  /// Instantiates a new [AppRouter].
  AppRouter({required this.authService}) {
    redirection = GoRouterRedirector();

    router = GoRouter(
      routes: AppRoutes.routes,
      initialLocation: AppRoutes.initialRoute.path,
      redirect: (context, GoRouterState state) {
        lastRouteState = RouteState.fromGoRouterState(state);
        final redirection = _redirect(authService.session);
        if (redirection != null) {
          lastRouteState = RouteState(
            uri: Uri.parse(redirection),
          );
          return redirection;
        }
        return null;
      },
    );

    _authSub = authService.listen((AuthSession? session) {
      _log.finest(
        'AuthState changed: AuthUser.id: ${session?.authUserId}',
      );
      final redirection = _redirect(session);
      if (redirection != null) {
        lastRouteState = RouteState(
          uri: Uri.parse(redirection),
        );
        router.go(redirection);
      }
    });
  }

  /// {@macro AuthService}
  final AuthService authService;

  StreamSubscription<AuthSession?>? _authSub;

  /// [GoRouter] instance.
  late final GoRouter router;

  /// Ye who keeps users from wandering off into the woods.
  late final GoRouterRedirector redirection;

  /// Cache of the last known [RouteState].
  RouteState? lastRouteState;

  final _redirections = StreamController<String?>.broadcast();

  /// Emits redirection decisions
  @visibleForTesting
  Stream<String?> get allRedirects => _redirections.stream;

  String? _redirect(AuthSession? session) {
    final redirect = redirection.redirect(
      routeState:
          lastRouteState ?? //
          RouteState.fromRoute(AppRoutes.initialRoute),
      session: session,
    );
    _redirections.add(redirect);
    return redirect;
  }

  void dispose() {
    _authSub?.cancel();
    _redirections.close();
  }
}
