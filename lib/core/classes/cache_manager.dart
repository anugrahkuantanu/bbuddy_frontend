import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Cache {
  // Create storage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Private constructor
  Cache._();

  // Singleton instance
  static final Cache _instance = Cache._();

  // Getter for instance
  static Cache get instance => _instance;

  Future<void> store(String key, dynamic value) async {
    if (value is int) {
      await _storage.write(key: key, value: value.toString());
    } else if (value is String) {
      await _storage.write(key: key, value: value);
    } else if (value is bool) {
      await _storage.write(key: key, value: value.toString());
    } else {
      print("Invalid Type");
    }
  }

  Future<dynamic> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clear() async {
    return await _storage.deleteAll();
  }
}

