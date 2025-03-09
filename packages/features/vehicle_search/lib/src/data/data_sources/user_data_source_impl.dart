import 'dart:convert';
import 'package:core/core.dart';
import 'user_data_source.dart';

class UserDataSourceImpl implements UserDataSource {
  final LocalStorage localStorage;
  static const String userKey = 'pref_user_key';

  UserDataSourceImpl({required this.localStorage});

  @override
  Future<String?> getUserId() async {
    final userData = await localStorage.getString(userKey);
    if (userData == null) return null;
    try {
      final userJson = jsonDecode(userData) as Map<String, dynamic>;
      return userJson['id'] as String?;
    } catch (_) {
      return null;
    }
  }
}
