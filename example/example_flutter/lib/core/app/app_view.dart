import 'package:example_flutter/core/routing/router.dart' show AppRouter;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Example app',
      debugShowCheckedModeBanner: false,
      routerConfig: GetIt.I<AppRouter>().router,
    );
  }
}
