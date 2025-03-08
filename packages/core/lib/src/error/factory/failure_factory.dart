// lib/core/error/failure_factory.dart


import 'package:core/core.dart';

typedef FailureCreator = Failure Function(Map<String, dynamic> data);

class FailureFactory {
  static final Map<String, FailureCreator> _creators = {};

  // Register a new failure type
  static void registerFailure(String errorKey, FailureCreator creator) {
    _creators[errorKey] = creator;
  }

  static Failure authenticationFailure(String message) {
    return IdentificationFailure(message);
  }

  static Failure networkFailure([String? message]) {
    return NetworkFailure(message ?? 'Network connection error');
  }

  static Failure storageFailure([String? message]) {
    return LocalStorageFailure(message ?? 'Storage error');
  }

  static Failure serverFailure(Map<String, dynamic> data) {
    final errorKey = data['msgKey'] as String? ?? 'server_error';
    return FailureFactory.createFailure(errorKey: errorKey, data: data);
  }

  static Failure deserializationFailure([String? message]) {
    return DeserializationFailure(message ?? 'Data parsing error');
  }

  static Failure unknownFailure(Object error) {
    return UnknownFailure('Unexpected error: $error');
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
  FailureFactory.registerFailure('identification_error', (data) {
    return IdentificationFailure(data['message'] ?? 'Identification Failure');
  });
  FailureFactory.registerFailure('local_storage_error', (data) {
    return IdentificationFailure(data['message'] ?? 'Local Storage Failure');
  });
  FailureFactory.registerFailure('unknown', (data) {
    return IdentificationFailure(data['message'] ?? 'Unknown Failure');
  });
}
