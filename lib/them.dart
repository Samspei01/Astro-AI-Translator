import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  bool _isDarkMode = true; // Default to dark mode
  int _textSize = 16;
  String selectedVoice = 'Default';
  String _themeMode = 'System'; // Default theme mode

  ThemeNotifier() {
    _loadPreferences();
  }

  bool get isDarkMode => _isDarkMode;
  int get textSize => _textSize;
  String get voice => selectedVoice;
  String get themeMode => _themeMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _savePreferences();
    notifyListeners();
  }

  void setTextSize(int size) {
    _textSize = size;
    _savePreferences();
    notifyListeners();
  }

  void setVoice(String voice) {
    selectedVoice = voice;
    _savePreferences();
    notifyListeners();
  }

  void setThemeMode(String mode) {
    _themeMode = mode;
    if (mode == 'System') {
      _isDarkMode = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    } else if (mode == 'Dark') {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
    _savePreferences();
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? true; // Default to dark mode
    _textSize = prefs.getInt('textSize') ?? 16;
    selectedVoice = prefs.getString('selectedVoice') ?? 'Default';
    _themeMode = prefs.getString('themeMode') ?? 'System';
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
    prefs.setInt('textSize', _textSize);
    prefs.setString('selectedVoice', selectedVoice);
    prefs.setString('themeMode', _themeMode);
  }
}
