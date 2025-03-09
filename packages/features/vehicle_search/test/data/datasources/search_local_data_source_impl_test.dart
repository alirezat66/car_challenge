// test/data/datasources/search_local_data_source_impl_test.dart
import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vehicle_selection/src/data/data_sources/search_local_data_source_impl.dart';
import 'package:vehicle_selection/src/data/models/auction_model.dart';
import 'package:vehicle_selection/src/domain/entities/auction.dart';

import 'user_data_source_repository_test.mocks.dart';

@GenerateMocks([LocalStorage])
void main() {
  late SearchLocalDataSourceImpl dataSource;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    dataSource = SearchLocalDataSourceImpl(mockLocalStorage);
  });

  group('getVehicleAuction', () {
    final testAuctionJson = {
      'id': 12345,
      'feedback': 'Good condition',
      'valuatedAt': '2021-01-01T00:00:00.000Z',
      'requestedAt': '2021-01-01T00:00:00.000Z',
      'createdAt': '2021-01-01T00:00:00.000Z',
      'updatedAt': '2021-01-01T00:00:00.000Z',
      'make': 'Toyota',
      'model': 'GT 86',
      'externalId': 'test-id',
      '_fk_sellerUser': 'seller123',
      'price': 10000,
      'positiveCustomerFeedback': true,
      '_fk_uuid_auction': 'auction-123',
      'inspectorRequestedAt': '2021-01-01T00:00:00.000Z',
      'origin': 'test',
      'estimationRequestId': 'est123',
    };
    final testAuctionJsonString = jsonEncode(testAuctionJson);

    test('should return AuctionModel when data exists in local storage',
        () async {
      // Arrange
      when(mockLocalStorage.getString(StorageKeys.vehicleAuctionKey))
          .thenAnswer((_) async => testAuctionJsonString);

      // Act
      final result = await dataSource.getVehicleAuction();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (auction) {
          expect(auction, isA<AuctionModel>());
          expect(auction.id, equals(12345));
          expect(auction.make, equals('Toyota'));
          expect(auction.model, equals('GT 86'));
        },
      );
      verify(mockLocalStorage.getString(StorageKeys.vehicleAuctionKey));
    });

    test('should return failure when no data exists in local storage',
        () async {
      // Arrange
      when(mockLocalStorage.getString(StorageKeys.vehicleAuctionKey))
          .thenAnswer((_) async => null);

      // Act
      final result = await dataSource.getVehicleAuction();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<LocalStorageFailure>());
          expect(failure.message, contains('No cached vehicle auction data'));
        },
        (_) => fail('Should return failure'),
      );
      verify(mockLocalStorage.getString(StorageKeys.vehicleAuctionKey));
    });

    test('should return failure when data in local storage is invalid',
        () async {
      // Arrange
      when(mockLocalStorage.getString(StorageKeys.vehicleAuctionKey))
          .thenAnswer((_) async => 'invalid json');

      // Act
      final result = await dataSource.getVehicleAuction();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<LocalStorageFailure>());
          expect(failure.message,
              contains('Error retrieving cached vehicle data'));
        },
        (_) => fail('Should return failure'),
      );
      verify(mockLocalStorage.getString(StorageKeys.vehicleAuctionKey));
    });
  });

  group('saveVehicleAuction', () {
    final testAuction = Auction(
      id: 12345,
      feedback: 'Good condition',
      valuatedAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
      requestedAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
      createdAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
      updatedAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
      make: 'Toyota',
      model: 'GT 86',
      externalId: 'test-id',
      fkSellerUser: 'seller123',
      price: 10000,
      positiveCustomerFeedback: true,
      fkUuidAuction: 'auction-123',
      inspectorRequestedAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
      origin: 'test',
      estimationRequestId: 'est123',
    );

    test('should save auction to local storage', () async {
      // Arrange
      when(mockLocalStorage.saveString(any, any)).thenAnswer((_) async => true);

      // Act
      await dataSource.saveVehicleAuction(testAuction);

      // Assert
      verify(mockLocalStorage.saveString(
        StorageKeys.vehicleAuctionKey,
        any,
      ));
    });
  });
}
