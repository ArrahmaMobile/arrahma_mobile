abstract class IStorageProvider {
  Future<String> getString(String key);
  Future<bool> setString(String key, String value);
}

abstract class IStorageService {
  Future<T> get<T>({T Function() defaultFn, bool private = false});
  Future<T> getWithKey<T>(String key,
      {T Function() defaultFn, bool private = false});
  Future<bool> set<T>(T value, {bool private = false});
  Future<bool> setWithKey<T>(String key, T value, {bool private = false});
}
