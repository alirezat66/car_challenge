import 'dart:convert';

import 'package:core/core.dart';
import 'package:user_identification/user_identification.dart';

abstract class LocalDataSource {
  /// Get the stored user model or null if not found
  Future<UserModel?> getUser();

  /// Save the user model
  Future<void> saveUser(UserModel user);
}

class LocalDataSourceImpl implements LocalDataSource {
  final LocalStorage localStorage;

  LocalDataSourceImpl(this.localStorage);

  @override
  Future<UserModel?> getUser() async {
    try {
      final jsonString = await localStorage.getString(StorageKeys.userKey);
      try {
        return UserModel.fromJson(
            jsonDecode(jsonString!) as Map<String, dynamic>);
      } catch (e) {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final jsonString = jsonEncode(user.toJson());

      await localStorage.saveString(StorageKeys.userKey, jsonString);
    } catch (e) {
      rethrow;
    }
  }
}
