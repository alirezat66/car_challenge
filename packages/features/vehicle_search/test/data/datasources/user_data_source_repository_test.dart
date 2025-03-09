// test/data/data_sources/user_data_source_impl_test.dart
import 'dart:convert';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vehicle_selection/src/data/data_sources/user_data_source_impl.dart';

import 'user_data_source_repository_test.mocks.dart';


@GenerateMocks([LocalStorage])
void main() {
  late UserDataSourceImpl dataSource;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    dataSource = UserDataSourceImpl(localStorage: mockLocalStorage);
  });

  group('getUserId', () {
    const testUserId = 'test-user-id';
    final testUserJson = jsonEncode({'id': testUserId});

    test('should return user ID when valid data exists', () async {
      // Arrange
      when(mockLocalStorage.getString(UserDataSourceImpl.userKey))
          .thenAnswer((_) async => testUserJson);

      // Act
      final result = await dataSource.getUserId();

      // Assert
      expect(result, equals(testUserId));
      verify(mockLocalStorage.getString(UserDataSourceImpl.userKey));
    });

    test('should return null when no data exists', () async {
      // Arrange
      when(mockLocalStorage.getString(UserDataSourceImpl.userKey))
          .thenAnswer((_) async => null);

      // Act
      final result = await dataSource.getUserId();

      // Assert
      expect(result, isNull);
      verify(mockLocalStorage.getString(UserDataSourceImpl.userKey));
    });

    test('should return null when invalid JSON is stored', () async {
      // Arrange
      when(mockLocalStorage.getString(UserDataSourceImpl.userKey))
          .thenAnswer((_) async => 'invalid json');

      // Act
      final result = await dataSource.getUserId();

      // Assert
      expect(result, isNull);
      verify(mockLocalStorage.getString(UserDataSourceImpl.userKey));
    });

    test('should handle exception from localStorage', () async {
      // Arrange
      when(mockLocalStorage.getString(UserDataSourceImpl.userKey))
          .thenThrow(Exception('Test exception'));

      // Act & Assert
      expect(() => dataSource.getUserId(), throwsA(isA<Exception>()));
      verify(mockLocalStorage.getString(UserDataSourceImpl.userKey));
    });
  });
}
