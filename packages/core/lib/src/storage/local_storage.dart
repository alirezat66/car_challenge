
abstract class LocalStorage {
  /// Saves a string value with the given key
  Future<bool> saveString(String key, String value);

  /// Retrieves a string value by key
  Future<String?> getString(String key);
}
