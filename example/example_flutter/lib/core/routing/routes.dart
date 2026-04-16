import 'package:example_flutter/screens/screens.dart';
import 'package:go_router/go_router.dart';

/// {@template AppRoutes}
/// Container for all possible routes. One version of this must exist per user
/// [Role].
/// {@endtemplate}
class AppRoutes {
  /// Login route.
  static final loginRoute = GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => const LoginScreen(),
  );
  static final homeRoute = GoRoute(
    path: '/home',
    name: 'home',
    builder: (context, state) => const HomeScreen(),
  );

  /// Starting route passed to [GoRouter].
  static final GoRoute initialRoute = homeRoute;

  /// All available routes.
  static final List<GoRoute> routes = [
    loginRoute,
    homeRoute,
  ];
}
