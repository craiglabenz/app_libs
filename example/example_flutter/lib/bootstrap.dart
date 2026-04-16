import 'package:example_flutter/core/app/app_view.dart';
import 'package:example_flutter/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:logging/logging.dart';

/// Application bootstrap.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await setUpDependencyInjection();

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(AppView());
}
