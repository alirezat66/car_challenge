// test/domain/entities/search_result_test.dart
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/src/domain/entities/search_result.dart';
import '../../../lib/src/domain/entities/vehicle_choice.dart';

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

    test('should identify result with multiple choices', () {
      // Arrange
      const result = SearchResult(choices: mockChoices);

      // Assert
      expect(result.hasMultipleChoices, isTrue);
      expect(result.hasSelectedOption, isFalse);
    });

    test('should identify result with selected option', () {
      // Arrange
      const result = SearchResult(selectedExternalId: 'test-id-1');

      // Assert
      expect(result.hasMultipleChoices, isFalse);
      expect(result.hasSelectedOption, isTrue);
    });

    test('should have correct props', () {
      // Arrange
      const result1 = SearchResult(
        choices: mockChoices,
        selectedExternalId: 'test-id-1',
      );

      const result2 = SearchResult(
        choices: mockChoices,
        selectedExternalId: 'test-id-1',
      );

      const differentResult = SearchResult(
        choices: mockChoices,
        selectedExternalId: 'test-id-2',
      );

      // Assert
      expect(result1, equals(result2));
      expect(result1, isNot(equals(differentResult)));
      expect(result1.props, [mockChoices, 'test-id-1']);
    });
  });
}
