import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:vehicle_selection/vehicle_search.dart';


class SearchVehicleByVin implements UseCase<SearchResult, String> {
  final SearchRepository repository;

  SearchVehicleByVin(this.repository);

  @override
  Future<Either<Failure, SearchResult>> call(String vin) {
    return repository.searchByVin(vin);
  }
}
