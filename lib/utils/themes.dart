import 'package:flutter/material.dart';

enum ThemeType {
  light,
  dark,
}

class ThemeSwitcher extends ChangeNotifier {
  ThemeSwitcher();

  ThemeData currTheme = themeDatas[ThemeType.light];

  static final Map<ThemeType, ThemeData> themeDatas = {
    ThemeType.light: ThemeData(
      iconTheme: IconThemeData(color: Colors.white),
      hoverColor: Colors.black,
      primaryColor: Color(0xFF241332),
      accentColor: Color(0xFFDB7093),
      canvasColor: Colors.white,
      highlightColor: Colors.black,
      backgroundColor: Colors.black38,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF467CE8),
          foregroundColor: Color(0xFF8946D5)),
      fontFamily: 'Ubuntu',
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        subtitle2: TextStyle(fontSize: 14.0, color: Colors.white),
        bodyText1: TextStyle(
            fontSize: 19.0, color: Colors.white, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 26.0, fontStyle: FontStyle.italic),
      ),
    ),
    ThemeType.dark: ThemeData(accentColor: Colors.lightBlue)
  };

  void setTheme(ThemeType themeEnum) {
    this.currTheme = themeDatas[themeEnum];
    notifyListeners();
  }

  ThemeData getTheme() {
    return this.currTheme;
  }
}
