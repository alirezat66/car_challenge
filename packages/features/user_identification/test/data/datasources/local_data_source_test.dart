import 'dart:convert';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:user_identification/user_identification.dart';

import 'local_data_source_test.mocks.dart';

@GenerateMocks([LocalStorage])
void main() {
  late LocalDataSourceImpl dataSource;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    dataSource = LocalDataSourceImpl(mockLocalStorage);
  });

  group('getUser', () {
    final tUserModel = UserModel('test-user-id');
    final tUserJson = jsonEncode(tUserModel.toJson());

    test('should return UserModel when data exists in localStorage', () async {
      // arrange
      when(mockLocalStorage.getString(any))
          .thenAnswer((_) async => Right(tUserJson));

      // act
      final result = await dataSource.getUser();

      // assert
      expect(result?.id, equals(tUserModel.id));
      verify(mockLocalStorage.getString(StorageKeys.userKey));
    });

    test('should return null when no data exists in localStorage', () async {
      // arrange
      when(mockLocalStorage.getString(any))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await dataSource.getUser();

      // assert
      expect(result, null);
      verify(mockLocalStorage.getString(StorageKeys.userKey));
    });

    test('should return null when localStorage returns failure', () async {
      // arrange
      when(mockLocalStorage.getString(any))
          .thenAnswer((_) async => Left(LocalStorageFailure()));

      // act
      final result = await dataSource.getUser();

      // assert
      expect(result, null);
      verify(mockLocalStorage.getString(StorageKeys.userKey));
    });

    test('should return null when json is invalid', () async {
      // arrange
      when(mockLocalStorage.getString(any))
          .thenAnswer((_) async => const Right('invalid json'));

      // act
      final result = await dataSource.getUser();

      // assert
      expect(result, null);
      verify(mockLocalStorage.getString(StorageKeys.userKey));
    });
  });

  group('saveUser', () {
    final tUserModel = UserModel('test-user-id');
    final tUserJson = jsonEncode(tUserModel.toJson());

    test('should call localStorage to save the user', () async {
      // arrange
      when(mockLocalStorage.saveString(any, any))
          .thenAnswer((_) async => const Right(true));

      // act
      await dataSource.saveUser(tUserModel);

      // assert
      verify(mockLocalStorage.saveString(StorageKeys.userKey, tUserJson));
    });

    test('should throw exception when localStorage returns failure', () async {
      // arrange
      when(mockLocalStorage.saveString(any, any))
          .thenAnswer((_) async => Left(LocalStorageFailure('Save failed')));

      // act & assert
      expect(
        () => dataSource.saveUser(tUserModel),
        throwsA(isA<Exception>()),
      );
      verify(mockLocalStorage.saveString(StorageKeys.userKey, tUserJson));
    });
  });
}
