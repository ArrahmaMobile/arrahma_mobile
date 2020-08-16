import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_provider.dart';

class SecureStorage implements IStorageProvider {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Future<String> getString(String key) async {
    return _storage.read(key: key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
    return true;
  }
}
