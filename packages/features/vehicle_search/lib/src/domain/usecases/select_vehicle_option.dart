import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import '../repositories/search_repository.dart';

class SelectVehicleOption implements UseCase<String, String> {
  final SearchRepository repository;

  SelectVehicleOption(this.repository);

  @override
  Future<Either<Failure, String>> call(String externalId) {
    return repository.selectVehicleOption(externalId);
  }
}
