import 'package:shared_preferences/shared_preferences.dart';

import 'storage_provider.dart';

class SharedPreferencesStorage implements IStorageProvider {
  const SharedPreferencesStorage(this.preferences);
  final SharedPreferences preferences;

  @override
  Future<String> getString(String key) async {
    return preferences.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    if (value == null) {
      preferences.remove(key);
      return true;
    }
    return preferences.setString(key, value);
  }
}
