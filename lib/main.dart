// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:type_fast/providers/theme_provider.dart';
import 'package:type_fast/services/statistics_service.dart';
import 'providers/typing_test_provider.dart';
import 'screens/typing_test_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StatisticsService().initialize();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => TypingTestProvider()),
      ],
      child: const TypeFastApp(),
    ),
  );
}

class TypeFastApp extends StatelessWidget {
  const TypeFastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'TypeFast',
          theme: themeProvider.theme,
          home: const TypingTestScreen(),
        );
      },
    );
  }
}
