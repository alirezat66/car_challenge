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
    final result = await localStorage.getString(StorageKeys.userKey);

    return result.fold(
      (failure) => null,
      (jsonString) {
        if (jsonString == null) {
          return null;
        }

        try {
          return UserModel.fromJson(
              jsonDecode(jsonString) as Map<String, dynamic>);
        } catch (e) {
          return null;
        }
      },
    );
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final jsonString = jsonEncode(user.toJson());

    final result =
        await localStorage.saveString(StorageKeys.userKey, jsonString);

    result.fold(
      (failure) => throw Exception('Failed to save user: ${failure.message}'),
      (_) => null,
    );
  }
}
