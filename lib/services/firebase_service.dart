import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _isInitialized = true;
    } catch (e, st) {
      // Keep app usable with local storage when Firebase config is missing.
      _isInitialized = false;
      log('Firebase initialization failed: $e', stackTrace: st);
    }
  }

  static Future<bool> saveRecord(Map<String, dynamic> record) async {
    if (!_isInitialized) {
      return false;
    }

    try {
      await FirebaseFirestore.instance.collection('attendance_records').add({
        ...record,
        'created_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e, st) {
      log('Firestore save failed: $e', stackTrace: st);
      return false;
    }
  }
}
