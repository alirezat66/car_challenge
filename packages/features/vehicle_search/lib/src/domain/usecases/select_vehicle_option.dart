import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:vehicle_selection/src/domain/entities/search_result.dart';
import '../repositories/search_repository.dart';

class SelectVehicleOption implements UseCase<SearchResult, String> {
  final SearchRepository repository;

  SelectVehicleOption(this.repository);

  @override
  Future<Either<Failure, SearchResult>> call(String externalId) {
    return repository.search(externalId: externalId);
  }
}
