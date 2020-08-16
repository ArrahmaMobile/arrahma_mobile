import 'package:arrahma_mobile_app/utils/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

import 'secure_storage.dart';
import 'shared_preferences_storage.dart';
import 'storage_provider.dart';

class StorageService implements IStorageService {
  const StorageService(this.preferences);
  final SharedPreferences preferences;

  @override
  Future<T> get<T>({T Function() defaultFn, bool private = false}) async {
    return getWithKey(T.toString(), defaultFn: defaultFn, private: private);
  }

  @override
  Future<T> getWithKey<T>(String key,
      {T Function() defaultFn, bool private = false}) async {
    final value = await getString(key, private: private);
    return (value != null ? JsonMapper.deserialize<T>(value) : null) ??
        defaultFn();
  }

  @override
  Future<String> getString(String key,
      {String Function() defaultFn, bool private = false}) async {
    return (await getProvider(private).getString(key)) ??
        (defaultFn != null ? defaultFn() : null);
  }

  @override
  Future<bool> set<T>(T value, {bool private = false}) {
    return setWithKey(T.toString(), value, private: private);
  }

  @override
  Future<bool> setWithKey<T>(String key, T value, {bool private = false}) {
    return setString(key, JsonMapper.serialize(value));
  }

  @override
  Future<bool> setString(String key, String value, {bool private = false}) {
    return getProvider(private).setString(key, value);
  }

  IStorageProvider getProvider(bool private) {
    return private && !AppUtils.isWeb
        ? SecureStorage()
        : SharedPreferencesStorage(preferences);
  }
}
