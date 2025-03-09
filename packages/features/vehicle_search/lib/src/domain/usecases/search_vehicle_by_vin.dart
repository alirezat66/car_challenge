import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:vehicle_selection/src/vehicle_search.dart';


class SearchVehicleByVin implements UseCase<SearchResult, String> {
  final VehicleSearchRepository repository;

  SearchVehicleByVin(this.repository);

  @override
  Future<Either<Failure, SearchResult>> call(String vin) {
    return repository.searchByVin(vin);
  }
}
