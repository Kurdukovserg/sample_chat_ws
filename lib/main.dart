import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:loggy/loggy.dart';

import 'core/injection/injection.dart';
import 'core/presentation/app/app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Loggy.initLoggy(
    logPrinter: StreamPrinter(const PrettyDeveloperPrinter()),
  );
  await initSl();
  runApp(const App());
}



