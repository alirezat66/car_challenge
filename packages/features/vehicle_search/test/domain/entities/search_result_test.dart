// test/domain/entities/search_result_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_selection/src/domain/entities/auction.dart';
import 'package:vehicle_selection/src/domain/entities/search_result.dart';
import 'package:vehicle_selection/src/domain/entities/vehicle_choice.dart';

void main() {
  group('SearchResult', () {
    const mockChoices = [
      VehicleChoice(
        make: 'Toyota',
        model: 'GT 86',
        containerName: 'Test Container',
        similarity: 80,
        externalId: 'test-id-1',
      ),
      VehicleChoice(
        make: 'Toyota',
        model: 'GT 86',
        containerName: 'Another Container',
        similarity: 50,
        externalId: 'test-id-2',
      ),
    ];

    final mockAuction = Auction(
      id: 12345,
      feedback: 'Good condition',
      valuatedAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
      requestedAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
      createdAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
      updatedAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
      make: 'Toyota',
      model: 'GT 86',
      externalId: 'test-id-1',
      fkSellerUser: 'seller123',
      price: 10000,
      positiveCustomerFeedback: true,
      fkUuidAuction: 'auction-123',
      inspectorRequestedAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
      origin: 'test',
      estimationRequestId: 'est123',
    );

    test(
        'should return isValid true when either auction or choices is set (but not both)',
        () {
      // Arrange
      final resultWithChoices = SearchResult(choices: mockChoices);
      final resultWithAuction = SearchResult(auction: mockAuction);
      final resultWithBoth =
          SearchResult(auction: mockAuction, choices: mockChoices);
      final emptyResult = const SearchResult();

      // Assert
      expect(resultWithChoices.isValid, isTrue);
      expect(resultWithAuction.isValid, isTrue);
      expect(resultWithBoth.isValid, isFalse); // Both set, should not be valid
      expect(emptyResult.isValid, isFalse); // None set, should not be valid
    });

    test('should have correct props', () {
      // Arrange
      final result1 = SearchResult(auction: mockAuction);
      final result2 = SearchResult(auction: mockAuction);
      final differentResult = SearchResult(choices: mockChoices);

      // Assert
      expect(result1, equals(result2));
      expect(result1, isNot(equals(differentResult)));
      expect(result1.props, [mockAuction, null]);
      expect(differentResult.props, [null, mockChoices]);
    });
  });

  group('VehicleChoice', () {
    test('should have correct props', () {
      // Arrange
      const choice1 = VehicleChoice(
        make: 'Toyota',
        model: 'GT 86',
        containerName: 'DE - Cp2 2.0 EU5, 2012 - 2015',
        similarity: 80,
        externalId: 'DE001-018601450020001',
      );

      const choice2 = VehicleChoice(
        make: 'Toyota',
        model: 'GT 86',
        containerName: 'DE - Cp2 2.0 EU5, 2012 - 2015',
        similarity: 80,
        externalId: 'DE001-018601450020001',
      );

      const differentChoice = VehicleChoice(
        make: 'Toyota',
        model: 'GT 86',
        containerName: 'DE - Cp2 2.0 EU6, 2015 - 2017',
        similarity: 50,
        externalId: 'DE002-018601450020001',
      );

      // Assert
      expect(choice1, equals(choice2)); // Same values should be equal
      expect(
          choice1,
          isNot(
              equals(differentChoice))); // Different values should not be equal

      // Check the props contain all fields
      expect(choice1.props, [
        'Toyota',
        'GT 86',
        'DE - Cp2 2.0 EU5, 2012 - 2015',
        80,
        'DE001-018601450020001',
      ]);
    });
  });
}
