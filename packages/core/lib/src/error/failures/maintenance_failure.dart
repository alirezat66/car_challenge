import 'package:core/core.dart';
class MaintenanceFailure extends Failure {
  int get delaySeconds => extraData!['delaySeconds'] as int;

  MaintenanceFailure({
    required int delaySeconds,
    String message = 'Maintenance Failure',
  }) : super(message, extraData: {'delaySeconds': delaySeconds});
}
