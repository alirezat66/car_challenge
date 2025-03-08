import 'package:core/src/storage/shared_preferences_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late SharedPreferencesStorage storage;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    storage = SharedPreferencesStorage(mockSharedPreferences);
  });

  group('SharedPreferencesStorage', () {
    const testKey = 'test_key';
    const testValue = 'test_value';

    test(
        'should return string value when there is a value in SharedPreferences',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(testValue);

      // act
      final result = await storage.getString(testKey);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return a value'),
        (value) => expect(value, testValue),
      );
      verify(mockSharedPreferences.getString(testKey));
    });

    test('should return null when there is no value in SharedPreferences',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final result = await storage.getString(testKey);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return a value'),
        (value) => expect(value, null),
      );
      verify(mockSharedPreferences.getString(testKey));
    });

    test('should return failure when getString throws an exception', () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenThrow(Exception('Test exception'));

      // act
      final result = await storage.getString(testKey);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalStorageFailure>()),
        (_) => fail('Should return a failure'),
      );
      verify(mockSharedPreferences.getString(testKey));
    });

    test('should call SharedPreferences to save a string value', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      // act
      final result = await storage.saveString(testKey, testValue);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return success'),
        (success) => expect(success, true),
      );
      verify(mockSharedPreferences.setString(testKey, testValue));
    });

    test('should return failure when saveString throws an exception', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any))
          .thenThrow(Exception('Test exception'));

      // act
      final result = await storage.saveString(testKey, testValue);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalStorageFailure>()),
        (_) => fail('Should return a failure'),
      );
      verify(mockSharedPreferences.setString(testKey, testValue));
    });
  });
}
