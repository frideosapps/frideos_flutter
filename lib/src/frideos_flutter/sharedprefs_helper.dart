import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// Helper class for the SharedPreferences package.
///
class Prefs {
  /// To save data as a key/value pair (it works with types: bool, int, double
  /// String).
  ///
  /// Usage:
  ///
  /// ```dart
  ///   Prefs.savePref<int>('Key', 1);
  /// ```
  static Future<void> savePref<T>(String key, T value) async {
    assert(T == bool || T == int || T == double || T == String);

    final prefs = await SharedPreferences.getInstance();

    switch (T) {
      case bool:
        await prefs.setBool(key, value as bool);
        break;
      case int:
        await prefs.setInt(key, value as int);
        break;
      case double:
        await prefs.setDouble(key, value as double);
        break;
      case String:
        await prefs.setString(key, value as String);
        break;
      case List:
        await prefs.setStringList(key, value as List<String>);
        break;
    }
  }

  /// To save a List<String> as a key/value pair .
  ///
  /// Usage:
  ///
  /// ```dart
  ///   Prefs.saveStringList('Key', ['test1', ['test2']);
  /// ```
  static Future<void> saveStringList(String key, List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, list);
  }

  /// To get the data associated with a key.
  ///
  /// Usage:
  ///
  /// ```dart
  ///   String str = await Prefs.getPref('Key');
  /// ```
  ///
  static Future<dynamic> getPref(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  /// To get all the keys saved.
  ///
  /// Usage:
  ///
  /// ```dart
  ///   var keys = await Prefs.getKeys('Key');
  /// ```
  static Future<Set<String>> getKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  /// To remove a key/value pair.
  ///
  /// Usage:
  ///
  /// ```dart
  ///   Prefs.remove('Key');
  /// ```
  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
