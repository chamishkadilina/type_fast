// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:type_fast/providers/theme_provider.dart';
import 'package:type_fast/screens/onboarding/onboarding_screen.dart';
import 'package:type_fast/screens/typing_test/typing_test_screen.dart';
import 'package:type_fast/services/notification_service.dart';
import 'package:type_fast/services/statistics_service.dart';
import 'providers/typing_test_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Preserve the splash screen until initialization is complete
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize services
  await StatisticsService().initialize();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize notifications and get permission status
  final hasPermission = await NotificationService().initNotification();

  // If no permission, ensure notifications are disabled
  if (!hasPermission) {
    await prefs.setBool('notificationsEnabled', false);
  }

  // Check if onboarding has been completed
  final bool onboardingCompleted =
      prefs.getBool('onboardingCompleted') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => TypingTestProvider()),
      ],
      child: TypeFastApp(onboardingCompleted: onboardingCompleted),
    ),
  );

  // Remove splash screen once app is initialized
  FlutterNativeSplash.remove();
}

class TypeFastApp extends StatelessWidget {
  final bool onboardingCompleted;

  const TypeFastApp({
    super.key,
    required this.onboardingCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'TypeFast',
          theme: themeProvider.theme,
          home: onboardingCompleted
              ? const TypingTestScreen()
              : const OnboardingScreen(),
        );
      },
    );
  }
}
