import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'experiments/exp04_navigation.dart';
import 'screens/main_shell.dart';
import 'screens/scan_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/tips_screen.dart';
import 'theme.dart';

void main() {
  runApp(
    // EXPERIMENT 5b: Provider at the root of the app.
    ChangeNotifierProvider(
      create: (_) => AppState()..load(),
      child: const DocScanApp(),
    ),
  );
}

class DocScanApp extends StatelessWidget {
  const DocScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return MaterialApp(
      title: 'DocScan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(state.seed, Brightness.light),
      darkTheme: AppTheme.build(state.seed, Brightness.dark),
      themeMode: state.themeMode,
      // EXPERIMENT 4b: named routes
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/': (_) => const MainShell(),
        '/scan': (_) => const ScanScreen(),
        '/tips': (_) => const TipsScreen(),
        '/settings': (_) => const SettingsScreen(),
        Exp4bFirstScreen.routeName: (_) => const Exp4bFirstScreen(),
        Exp4bSecondScreen.routeName: (_) => const Exp4bSecondScreen(),
      },
    );
  }
}
