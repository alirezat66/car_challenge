// test/domain/entities/vehicle_choice_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_selection/vehicle_search.dart';

void main() {
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
