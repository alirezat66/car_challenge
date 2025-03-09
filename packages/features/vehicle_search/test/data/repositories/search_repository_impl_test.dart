// test/data/repositories/search_repository_impl_test.dart
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vehicle_selection/src/data/data_sources/search_local_data_source.dart';
import 'package:vehicle_selection/src/data/data_sources/search_remote_data_source.dart';
import 'package:vehicle_selection/src/data/data_sources/user_data_source.dart';
import 'package:vehicle_selection/src/data/models/auction_model.dart';
import 'package:vehicle_selection/src/data/repositories/search_repository_impl.dart';
import 'package:vehicle_selection/src/domain/entities/auction.dart';
import 'package:vehicle_selection/src/domain/entities/search_result.dart';
import 'package:vehicle_selection/src/domain/entities/vehicle_choice.dart';

import 'search_repository_impl_test.mocks.dart';

@GenerateMocks([SearchRemoteDataSource, SearchLocalDataSource, UserDataSource])
void main() {
  late SearchRepositoryImpl repository;
  late MockSearchRemoteDataSource mockRemoteDataSource;
  late MockSearchLocalDataSource mockLocalDataSource;
  late MockUserDataSource mockUserDataSource;

  setUp(() {
    mockRemoteDataSource = MockSearchRemoteDataSource();
    mockLocalDataSource = MockSearchLocalDataSource();
    mockUserDataSource = MockUserDataSource();
    repository = SearchRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      userDataSource: mockUserDataSource,
    );
  });

  const testUserId = 'test-user-id';
  const testVin = 'TEST12345678901234';
  const testExternalId = 'DE001-018601450020001';

  // Create sample auction
  final testAuction = Auction(
    id: 12345,
    feedback: "Good condition",
    valuatedAt: DateTime.parse("2023-01-01T10:00:00Z"),
    requestedAt: DateTime.parse("2023-01-01T09:00:00Z"),
    createdAt: DateTime.parse("2023-01-01T08:00:00Z"),
    updatedAt: DateTime.parse("2023-01-01T11:00:00Z"),
    make: "Toyota",
    model: "GT 86",
    externalId: testExternalId,
    fkSellerUser: "user123",
    price: 25000,
    positiveCustomerFeedback: true,
    fkUuidAuction: "auction-123",
    inspectorRequestedAt: DateTime.parse("2023-01-01T09:30:00Z"),
    origin: "dealer",
    estimationRequestId: "est123",
  );

  final testAuctionModel = AuctionModel.fromEntity(testAuction);

  // Create sample vehicle choices
  final testVehicleChoices = [
    const VehicleChoice(
      make: 'Toyota',
      model: 'GT 86',
      containerName: 'Test Container',
      similarity: 80,
      externalId: 'test-id-1',
    ),
  ];

  group('search', () {
    test('should return auction from remote data source on success', () async {
      // Arrange
      when(mockUserDataSource.getUserId()).thenAnswer((_) async => testUserId);
      when(mockRemoteDataSource.search(testUserId, vin: testVin))
          .thenAnswer((_) async => Right(SearchResult(auction: testAuction)));

      // Act
      final result = await repository.search(vin: testVin);

      // Assert
      expect(result, Right(SearchResult(auction: testAuction)));
      verify(mockUserDataSource.getUserId());
      verify(mockRemoteDataSource.search(testUserId, vin: testVin));
      verify(mockLocalDataSource.saveVehicleAuction(testAuction));
    });

    test(
        'should return vehicle choices from remote data source on 300 response',
        () async {
      // Arrange
      when(mockUserDataSource.getUserId()).thenAnswer((_) async => testUserId);
      when(mockRemoteDataSource.search(testUserId, vin: testVin)).thenAnswer(
          (_) async => Right(SearchResult(choices: testVehicleChoices)));

      // Act
      final result = await repository.search(vin: testVin);

      // Assert
      expect(result, Right(SearchResult(choices: testVehicleChoices)));
      verify(mockUserDataSource.getUserId());
      verify(mockRemoteDataSource.search(testUserId, vin: testVin));
      // No caching for choices response
      verifyNever(mockLocalDataSource.saveVehicleAuction(any));
    });

    test('should return failure when user is not authenticated', () async {
      // Arrange
      when(mockUserDataSource.getUserId()).thenAnswer((_) async => null);

      // Act
      final result = await repository.search(vin: testVin);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should return failure'),
      );
      verify(mockUserDataSource.getUserId());
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return cached auction when remote data source fails',
        () async {
      // Arrange
      final failure = NetworkFailure('Network error');
      when(mockUserDataSource.getUserId()).thenAnswer((_) async => testUserId);
      when(mockRemoteDataSource.search(testUserId, vin: testVin))
          .thenAnswer((_) async => Left(failure));
      when(mockLocalDataSource.getVehicleAuction())
          .thenAnswer((_) async => Right(testAuctionModel));

      // Act
      final result = await repository.search(vin: testVin);

      // Assert
      expect(result.isRight(), true);
      verify(mockUserDataSource.getUserId());
      verify(mockRemoteDataSource.search(testUserId, vin: testVin));
      verify(mockLocalDataSource.getVehicleAuction());
      verifyNever(mockLocalDataSource.saveVehicleAuction(any));
    });

    test('should return original failure when both remote and cache fail',
        () async {
      // Arrange
      final remoteFailure = NetworkFailure('Network error');
      final cacheFailure = LocalStorageFailure('Cache error');

      when(mockUserDataSource.getUserId()).thenAnswer((_) async => testUserId);
      when(mockRemoteDataSource.search(testUserId, vin: testVin))
          .thenAnswer((_) async => Left(remoteFailure));
      when(mockLocalDataSource.getVehicleAuction())
          .thenAnswer((_) async => Left(cacheFailure));

      // Act
      final result = await repository.search(vin: testVin);

      // Assert
      expect(
          result, Left(remoteFailure)); // Should return original remote failure
      verify(mockUserDataSource.getUserId());
      verify(mockRemoteDataSource.search(testUserId, vin: testVin));
      verify(mockLocalDataSource.getVehicleAuction());
    });

    test('should handle exceptions and return unknown failure', () async {
      // Arrange
      when(mockUserDataSource.getUserId()).thenThrow(Exception('Test error'));

      // Act
      final result = await repository.search(vin: testVin);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should return failure'),
      );
      verify(mockUserDataSource.getUserId());
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should perform search with externalId when provided', () async {
      // Arrange
      when(mockUserDataSource.getUserId()).thenAnswer((_) async => testUserId);
      when(mockRemoteDataSource.search(testUserId, externalId: testExternalId))
          .thenAnswer((_) async => Right(SearchResult(auction: testAuction)));

      // Act
      final result = await repository.search(externalId: testExternalId);

      // Assert
      expect(result.isRight(), true);
      verify(mockUserDataSource.getUserId());
      verify(
          mockRemoteDataSource.search(testUserId, externalId: testExternalId));
      verify(mockLocalDataSource.saveVehicleAuction(testAuction));
    });
  });
}
