import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage implements LocalStorage {
  final SharedPreferences sharedPreferences;

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
