import 'package:car_challenge/features/vehicle_selection/presentation/pages/search/validator/vin_validation_mixin.dart';
import 'package:flutter_test/flutter_test.dart';

// Create a test class that uses the mixin
class TestClass with VinValidationMixin {}

void main() {
  late TestClass validator;

  setUp(() {
    validator = TestClass();
  });

  group('VinValidationMixin', () {
    test('should return error message when VIN is null', () {
      final result = validator.validateVin(null);
      expect(result, 'Please enter a VIN');
    });

    test('should return error message when VIN is empty', () {
      final result = validator.validateVin('');
      expect(result, 'Please enter a VIN');
    });

    test('should return error message when VIN length is not 17', () {
      // Test with shorter VIN
      final resultShorter = validator.validateVin('ABC12345');
      expect(resultShorter, 'VIN must be exactly 17 characters');

      // Test with longer VIN
      final resultLonger = validator.validateVin('WVWZZZ1KZAW123456789');
      expect(resultLonger, 'VIN must be exactly 17 characters');
    });

    test('should return null when VIN is valid (17 characters)', () {
      final result = validator.validateVin('WVWZZZ1KZAW123456');
      expect(result, null);
    });
  });
}
