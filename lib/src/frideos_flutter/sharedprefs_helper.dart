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
  static savePref<T>(String key, T value) async {
    assert(T == bool || T == int || T == double || T == String);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (T) {
      case bool:
        prefs.setBool(key, value as bool);
        break;
      case int:
        prefs.setInt(key, value as int);
        break;
      case double:
        prefs.setDouble(key, value as double);
        break;
      case String:
        prefs.setString(key, value as String);
        break;
      case List:
        prefs.setStringList(key, value as List<String>);
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
  static saveStringList(String key, List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, list);
  }

  /// To get the data associated with a key.
  ///
  /// Usage:
  ///
  /// ```dart
  ///   String str = await Prefs.getPref('Key');
  /// ```
  ///
  static dynamic getPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pref = prefs.get(key);
    return pref;
  }

  /// To get all the keys saved.
  ///
  /// Usage:
  ///
  /// ```dart
  ///   var keys = await Prefs.getKeys('Key');
  /// ```
  static Future<Set<String>> getKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var keys = prefs.getKeys();
    return keys;
  }

  /// To remove a key/value pair.
  ///
  /// Usage:
  ///
  /// ```dart
  ///   Prefs.remove('Key');
  /// ```
  static Future<bool> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
