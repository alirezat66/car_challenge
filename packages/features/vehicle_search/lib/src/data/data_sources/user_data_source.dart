// lib/src/data/datasources/user_data_source.dart
abstract class UserDataSource {
  /// Returns the user ID for API requests
  /// Returns null if no user is found
  Future<String?> getUserId();
}
