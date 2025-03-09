import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import '../repositories/vehicle_search_repository.dart';

class SelectVehicleOption implements UseCase<String, String> {
  final VehicleSearchRepository repository;

  SelectVehicleOption(this.repository);

  @override
  Future<Either<Failure, String>> call(String externalId) {
    return repository.selectVehicleOption(externalId);
  }
}
