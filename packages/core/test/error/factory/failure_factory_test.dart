import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    setupFailureFactory();
  });

  group('FailureFactory Tests', () {
    test('should create MaintenanceFailure', () {
      final failure = FailureFactory.createFailure(
        errorKey: 'maintenance',
        data: {
          'message': 'Maintenance in progress',
          'params': {'delaySeconds': 45},
        },
      );
      expect(failure, isA<MaintenanceFailure>());
      expect(failure.message, 'Maintenance in progress');
      expect((failure as MaintenanceFailure).delaySeconds, 45);
    });

    test('should create ServerFailure', () {
      final failure = FailureFactory.createFailure(
        errorKey: 'server_error',
        data: {'message': 'Server is down'},
      );
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Server is down');
    });

    test('should create NetworkFailure', () {
      final failure = FailureFactory.createFailure(
        errorKey: 'network_error',
        data: {'message': 'No internet connection'},
      );
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'No internet connection');
    });

    test('should create DeserializationFailure', () {
      final failure = FailureFactory.createFailure(
        errorKey: 'deserialization_error',
        data: {'message': 'Invalid JSON format'},
      );
      expect(failure, isA<DeserializationFailure>());
      expect(failure.message, 'Invalid JSON format');
    });

    test('should create UnknownFailure for unknown errorKey', () {
      final failure = FailureFactory.createFailure(
        errorKey: 'unknown_error',
        data: {},
      );
      expect(failure, isA<UnknownFailure>());
      expect(failure.message, 'Unknown error: unknown_error');
    });
  });
}
