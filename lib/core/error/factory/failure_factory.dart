// lib/core/error/failure_factory.dart
import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/core/error/failures.dart';

typedef FailureCreator = Failure Function(Map<String, dynamic> data);

class FailureFactory {
  static final Map<String, FailureCreator> _creators = {};

  // Register a new failure type
  static void registerFailure(String errorKey, FailureCreator creator) {
    _creators[errorKey] = creator;
  }

  // Create a failure based on error key and data
  static Failure createFailure({
    required String errorKey,
    required Map<String, dynamic> data,
  }) {
    final creator = _creators[errorKey];
    if (creator != null) {
      return creator(data);
    }
    return UnknownFailure('Unknown error: $errorKey');
  }
}

// Register failure types during initialization
void setupFailureFactory() {
  FailureFactory.registerFailure('maintenance', (data) {
    return MaintenanceFailure(
      message: data['message'] ?? 'Maintenance Failure',
      delaySeconds: int.parse(data['params']['delaySeconds'].toString()),
    );
  });

  FailureFactory.registerFailure('server_error', (data) {
    return ServerFailure(data['message'] ?? 'Server Failure');
  });

  FailureFactory.registerFailure('network_error', (data) {
    return NetworkFailure(data['message'] ?? 'Network Failure');
  });

  FailureFactory.registerFailure('deserialization_error', (data) {
    return DeserializationFailure(data['message'] ?? 'Deserialization Failure');
  });
}
