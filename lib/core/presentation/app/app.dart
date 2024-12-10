import 'package:flutter/material.dart';

import '../../injection/injection.dart';
import '../../routing/router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppRouter _router = sl();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chat app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: _router.config(),
      builder: (context, child) => child!,
    );
  }
}
