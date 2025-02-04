// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/services/statistics_service.dart';
import 'providers/typing_test_provider.dart';
import 'screens/typing_test_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await StatisticsService().initialize();
  runApp(const TypeFastApp());
}

class TypeFastApp extends StatelessWidget {
  const TypeFastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TypingTestProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'TypeFast',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const TypingTestScreen(),
      ),
    );
  }
}
