import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vehicle_selection/vehicle_search.dart';

import 'search_vehicle_by_vin_test.mocks.dart';

@GenerateMocks([SearchRepository])
void main() {
  group('SearchVehicleByVin', () {
    late SearchVehicleByVin usecase;
    late MockSearchRepository mockRepository;

    setUp(() {
      mockRepository = MockSearchRepository();
      usecase = SearchVehicleByVin(mockRepository);
    });

    const testVin = 'WVWZZZ1KZAW123456';
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

    final testChoices = [
      const VehicleChoice(
        make: 'Toyota',
        model: 'GT 86',
        containerName: 'Test Container',
        similarity: 80,
        externalId: 'test-id-1',
      ),
    ];

    test('should get auction from the repository when call succeeds', () async {
      // Arrange
      final testResult = SearchResult(auction: testAuction);
      when(mockRepository.search(vin: testVin))
          .thenAnswer((_) async => Right(testResult));

      // Act
      final result = await usecase(testVin);

      // Assert
      expect(result, Right(testResult));
      verify(mockRepository.search(vin: testVin));
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'should get choices from the repository when call returns multiple options',
        () async {
      // Arrange
      final testResult = SearchResult(choices: testChoices);
      when(mockRepository.search(vin: testVin))
          .thenAnswer((_) async => Right(testResult));

      // Act
      final result = await usecase(testVin);

      // Assert
      expect(result, Right(testResult));
      verify(mockRepository.search(vin: testVin));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final failure = NetworkFailure('Network error');
      when(mockRepository.search(vin: testVin))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(testVin);

      // Assert
      expect(result, Left(failure));
      verify(mockRepository.search(vin: testVin));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('SelectVehicleOption', () {
    late SelectVehicleOption usecase;
    late MockSearchRepository mockRepository;

    setUp(() {
      mockRepository = MockSearchRepository();
      usecase = SelectVehicleOption(mockRepository);
    });

    const testExternalId = 'DE001-018601450020001';
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

    test('should call repository and return auction result', () async {
      // Arrange
      final testResult = SearchResult(auction: testAuction);
      when(mockRepository.search(externalId: testExternalId))
          .thenAnswer((_) async => Right(testResult));

      // Act
      final result = await usecase(testExternalId);

      // Assert
      expect(result, Right(testResult));
      verify(mockRepository.search(externalId: testExternalId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final failure = ServerFailure('Server error');
      when(mockRepository.search(externalId: testExternalId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(testExternalId);

      // Assert
      expect(result, Left(failure));
      verify(mockRepository.search(externalId: testExternalId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
