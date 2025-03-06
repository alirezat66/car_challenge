import 'dart:convert';

import 'package:car_challenge/core/constants/pref_keys.dart';
import 'package:car_challenge/features/user_identification/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  final SharedPreferences _preferences;
  LocalDataSource(SharedPreferences preferences) : _preferences = preferences;

  UserModel? getUser() {
    final userJson = _preferences.getString(userKey);
    return userJson != null ? UserModel.fromJson(jsonDecode(userJson)) : null;
  }

  Future<void> saveUser(UserModel user) async {
    await _preferences.setString(userKey, jsonEncode(user.toJson()));
  }
}
