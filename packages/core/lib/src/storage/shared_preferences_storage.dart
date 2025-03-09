import 'package:core/core.dart';

class SharedPreferencesStorage implements LocalStorage {
  final dynamic sharedPreferences;

  SharedPreferencesStorage(this.sharedPreferences);

  @override
  Future<bool> saveString(String key, String value) async {
    try {
      return await sharedPreferences.setString(key, value);
    } catch (e) {
      throw Exception(
          FailureFactory.storageFailure('Error saving string value: $e')
              .message);
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return sharedPreferences.getString(key);
    } catch (e) {
      throw Exception(
          FailureFactory.storageFailure('Error reading string value: $e')
              .message);
    }
  }
}
