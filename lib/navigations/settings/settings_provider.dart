import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  double _fontSize = 16.0;
  Color _backgroundColor = Colors.white;
  Color _appBarColor = Colors.pink;
  MaterialColor _themeColor = Colors.pink;
  

  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  Color get backgroundColor => _backgroundColor;
  Color get appBarColor => _appBarColor;
  MaterialColor get themeColor => _themeColor;

  void updateDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void updateFontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  void updateBackgroundColor(Color color) {
  _backgroundColor = color;
  notifyListeners();
}

void updateAppBarColor(Color color) {
  _appBarColor = color;
  notifyListeners();
}

  void updateThemeColor(MaterialColor color) {
    _themeColor = color;
    notifyListeners();
  }

  void loadFromMap(Map<String, dynamic> data) {
  _isDarkMode = data['darkMode'] ?? false;
  _fontSize = (data['fontSize'] ?? 16).toDouble();
  _backgroundColor = Color(data['backgroundColor'] ?? Colors.white.value);
  _appBarColor = Color(data['appBarColor'] ?? Colors.pink.value);
  _themeColor = _materialColorFromInt(data['themeColor']) ?? Colors.pink;

  notifyListeners();
}


  Map<String, dynamic> toMap() {
    return {
      'darkMode': _isDarkMode,
      'fontSize': _fontSize,
      'backgroundColor': _backgroundColor.value,
      'appBarColor': _appBarColor.value,
      'themeColor': _themeColor.value,
    };
  }

  MaterialColor? _materialColorFromInt(int? value) {
    if (value == null) return null;
    for (var swatch in Colors.primaries) {
      if (swatch.value == value) return swatch;
    }
    return null;
  }
}
