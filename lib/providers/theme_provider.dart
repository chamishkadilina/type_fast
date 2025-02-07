// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  final SharedPreferences _prefs;

  ThemeProvider(this._prefs) {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get theme => _isDarkMode ? darkTheme : lightTheme;

  void _loadTheme() {
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFDBEAF9),
    primaryColor: const Color(0xFF4A90E2),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFDBEAF9),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF2F4050)),
      titleTextStyle: TextStyle(
        color: Color(0xFF2F4050),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF2F4050)),
      bodyMedium: TextStyle(color: Color(0xFF2F4050)),
      titleLarge: TextStyle(color: Color(0xFF2F4050)),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF2F4050)),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black87,
    primaryColor: const Color(0xFF4A90E2),
    cardColor: const Color(0xFF1E1E1E),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black87,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white70),
      titleTextStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
      bodyMedium: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
      titleLarge: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
  );
}
