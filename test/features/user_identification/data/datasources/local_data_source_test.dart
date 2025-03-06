import 'dart:convert';

import 'package:car_challenge/core/constants/pref_keys.dart';
import 'package:car_challenge/features/user_identification/data/datasources/local_data_source.dart';
import 'package:car_challenge/features/user_identification/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late LocalDataSource dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalDataSource(mockSharedPreferences);
  });

  group('LocalDataSource', () {
    final userModel = UserModel('123');
    final userJson = jsonEncode(userModel.toJson());

    test('should return UserModel when there is a saved user', () {
      when(mockSharedPreferences.getString(any)).thenReturn(userJson);

      final result = dataSource.getUser();

      expect(result?.id ?? '', userModel.id);
      verify(mockSharedPreferences.getString(userKey));
      verifyNoMoreInteractions(mockSharedPreferences);
    });

    test('should return null when there is no saved user', () {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final result = dataSource.getUser();

      expect(result, null);
      verify(mockSharedPreferences.getString(userKey));
      verifyNoMoreInteractions(mockSharedPreferences);
    });

    test('should call SharedPreferences to save the user', () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      await dataSource.saveUser(userModel);

      verify(mockSharedPreferences.setString(userKey, userJson));
      verifyNoMoreInteractions(mockSharedPreferences);
    });
  });
}
