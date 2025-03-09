// test/data/repositories/search_repository_impl_test.dart
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vehicle_selection/src/data/data_sources/search_remote_data_source.dart';
import 'package:vehicle_selection/src/data/data_sources/user_data_source.dart';
import 'package:vehicle_selection/src/data/repositories/search_repository_impl.dart';
import 'package:vehicle_selection/src/domain/entities/search_result.dart';
import 'package:vehicle_selection/src/domain/entities/vehicle_choice.dart';

import 'search_repository_impl_test.mocks.dart';

@GenerateMocks([SearchRemoteDataSource, UserDataSource])

void main() {
  late SearchRepositoryImpl repository;
  late MockSearchRemoteDataSource mockRemoteDataSource;
  late MockUserDataSource mockUserDataSource;

  setUp(() {
    mockRemoteDataSource = MockSearchRemoteDataSource();
    mockUserDataSource = MockUserDataSource();
    repository = SearchRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      userDataSource: mockUserDataSource,
    );
  });

  const testUserId = 'test-user-id';
  const testVin = 'TEST12345678901234';
  const testExternalId = 'DE001-018601450020001';

  group('searchByVin', () {
    final testVehicleChoices = [
      const VehicleChoice(
        make: 'Toyota',
        model: 'GT 86',
        containerName: 'Test Container',
        similarity: 80,
        externalId: 'test-id-1',
      ),
    ];
    final testSearchResult = SearchResult(choices: testVehicleChoices);

    test('should return search result when user is authenticated', () async {
      // Arrange
      when(mockUserDataSource.getUserId()).thenAnswer((_) async => testUserId);
      when(mockRemoteDataSource.searchByVin(testUserId, testVin))
          .thenAnswer((_) async => Right(testSearchResult));

      // Act
      final result = await repository.searchByVin(testVin);

      // Assert
      expect(result, Right(testSearchResult));
      verify(mockUserDataSource.getUserId());
      verify(mockRemoteDataSource.searchByVin(testUserId, testVin));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return failure when user is not authenticated', () async {
      // Arrange
      when(mockUserDataSource.getUserId()).thenAnswer((_) async => null);

      // Act
      final result = await repository.searchByVin(testVin);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should return failure'),
      );
      verify(mockUserDataSource.getUserId());
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should return failure when remote data source fails', () async {
      // Arrange
      final failure = NetworkFailure('Network error');
      when(mockUserDataSource.getUserId()).thenAnswer((_) async => testUserId);
      when(mockRemoteDataSource.searchByVin(testUserId, testVin))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await repository.searchByVin(testVin);

      // Assert
      expect(result, Left(failure));
      verify(mockUserDataSource.getUserId());
      verify(mockRemoteDataSource.searchByVin(testUserId, testVin));
    });

    test('should return failure when user data source throws', () async {
      // Arrange
      when(mockUserDataSource.getUserId()).thenThrow(Exception('Test error'));

      // Act
      final result = await repository.searchByVin(testVin);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should return failure'),
      );
      verify(mockUserDataSource.getUserId());
      verifyZeroInteractions(mockRemoteDataSource);
    });
  });

  group('selectVehicleOption', () {
    const testAuctionId = 'auction-123';

    test('should return auction ID when user is authenticated', () async {
      // Arrange
      when(mockUserDataSource.getUserId()).thenAnswer((_) async => testUserId);
      when(mockRemoteDataSource.selectVehicleOption(testUserId, testExternalId))
          .thenAnswer((_) async => const Right(testAuctionId));

      // Act
      final result = await repository.selectVehicleOption(testExternalId);

      // Assert
      expect(result, const Right(testAuctionId));
      verify(mockUserDataSource.getUserId());
      verify(
          mockRemoteDataSource.selectVehicleOption(testUserId, testExternalId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return failure when user is not authenticated', () async {
      // Arrange
      when(mockUserDataSource.getUserId()).thenAnswer((_) async => null);

      // Act
      final result = await repository.selectVehicleOption(testExternalId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should return failure'),
      );
      verify(mockUserDataSource.getUserId());
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should return failure when remote data source fails', () async {
      // Arrange
      final failure = ServerFailure('Server error');
      when(mockUserDataSource.getUserId()).thenAnswer((_) async => testUserId);
      when(mockRemoteDataSource.selectVehicleOption(testUserId, testExternalId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await repository.selectVehicleOption(testExternalId);

      // Assert
      expect(result, Left(failure));
      verify(mockUserDataSource.getUserId());
      verify(
          mockRemoteDataSource.selectVehicleOption(testUserId, testExternalId));
    });

    test('should return failure when user data source throws', () async {
      // Arrange
      when(mockUserDataSource.getUserId()).thenThrow(Exception('Test error'));

      // Act
      final result = await repository.selectVehicleOption(testExternalId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should return failure'),
      );
      verify(mockUserDataSource.getUserId());
      verifyZeroInteractions(mockRemoteDataSource);
    });
  });
}
