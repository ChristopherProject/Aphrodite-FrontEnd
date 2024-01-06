import 'package:aphrodite/utilitities/colors.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AppTheme with ChangeNotifier {
  late SharedPreferences _preferences;

  ThemeData _currentTheme = lightTheme;

  AppTheme() {
    init();
  }

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _loadThemeFromPreferences();
  }

  ThemeData get currentTheme => _currentTheme;

  void _loadThemeFromPreferences() {
    bool isDarkMode = _preferences.getBool('isDarkMode') ?? false;
    _currentTheme = isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }

  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColorLight,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColorLight,
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppColors.primaryColorDark,
    scaffoldBackgroundColor: AppColors.primaryColorDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(221, 20, 20, 20),
    ),
  );

  Future<void> toggleTheme() async {
    bool isDarkMode = _preferences.getBool('isDarkMode') ?? false;
    await _preferences.setBool('isDarkMode', !isDarkMode);
    _loadThemeFromPreferences();
  }
}
