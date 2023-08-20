import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Create storage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Private constructor
  SecureStorage._();

  // Singleton instance
  static final SecureStorage _instance = SecureStorage._();

  // Getter for instance
  static SecureStorage get instance => _instance;

  Future<void> store(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> clear() async {
    return await _storage.deleteAll();
  }
}
