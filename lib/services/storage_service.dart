import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _key = 'attendance_data';

  // Save a new record to the list
  static Future<void> saveRecord(Map<String, dynamic> record) async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString(_key);
    
    List<dynamic> records = [];
    if (existingData != null) {
      records = jsonDecode(existingData);
    }
    
    records.add(record);
    await prefs.setString(_key, jsonEncode(records));
  }

  // Retrieve all records
  static Future<List<Map<String, dynamic>>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString(_key);
    
    if (existingData == null) return [];
    
    return List<Map<String, dynamic>>.from(jsonDecode(existingData));
  }
}
