import 'package:flutter_test/flutter_test.dart';
import 'package:car_challenge/core/error/failures.dart';

void main() {
  group('Failure Tests', () {
    test('DeserializationFailure should have correct message', () {
      final failure = DeserializationFailure();
      expect(failure.message, 'Deserialization Failure');
    });

    test('MaintenanceFailure should have correct message and delaySeconds', () {
      final failure = MaintenanceFailure(delaySeconds: 30);
      expect(failure.message, 'Maintenance Failure');
      expect(failure.delaySeconds, 30);
    });

    test('NetworkFailure should have correct message', () {
      final failure = NetworkFailure();
      expect(failure.message, 'Network Failure');
    });

    test('ServerFailure should have correct message', () {
      final failure = ServerFailure();
      expect(failure.message, 'Server Failure');
    });

    test('UnknownFailure should have correct message', () {
      final failure = UnknownFailure();
      expect(failure.message, 'Unknown Failure');
    });
  });
}
