// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static void saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      print("Invalid Type");
    }
  }

  static void saveListData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? obj = prefs.getStringList(key);
    if (obj != null) {
      obj.add(value);
      prefs.setStringList(key, obj);
    } else {
      prefs.setStringList(key, value);
    }
  }

  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }
  static Future<List<String>?> readListData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? obj = prefs.getStringList(key);
    return obj;
  }

  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
