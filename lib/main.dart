import 'package:flutter/material.dart';

import 'app.dart';
import 'core/config/app_env.dart';
import 'core/storage/app_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.init();
  await AppStorage.init();
  runApp(const AiotApp());
}
