import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeSP{
  static addBoolThemeMode(themeMode) async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    // set value
    prefs.setBool('themeMode', themeMode);
  }

  static getBoolThemeMode() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the counter key. If it doesn't exist, return 0.
    final myBool = prefs.getBool('themeMode');
    // print('themeMode: ${myBool}');
    if(myBool == null){
      return false;
    }
    return myBool;
  }
}
