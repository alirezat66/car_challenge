import 'package:car_challenge/core/error/failure.dart';

class DeserializationFailure extends Failure {
  DeserializationFailure([super.message = 'Deserialization Failure']);
}

class MaintenanceFailure extends Failure {
  int get delaySeconds => extraData!['delaySeconds'] as int;

  MaintenanceFailure({
    required int delaySeconds,
    String message = 'Maintenance Failure',
  }) : super(message, extraData: {'delaySeconds': delaySeconds});
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'Network Failure']);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = 'Server Failure']);
}

class UnknownFailure extends Failure {
  UnknownFailure([super.message = 'Unknown Failure']);
}
