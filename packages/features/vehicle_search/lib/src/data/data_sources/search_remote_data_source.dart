import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:vehicle_selection/src/domain/entities/search_result.dart';

abstract class SearchRemoteDataSource {
  /// Calls the remote API to search for vehicles by VIN
  /// Returns Either with Failure or SearchResult
  Future<Either<Failure, SearchResult>> searchByVin(String userId, String vin);

  /// Calls the remote API to select a specific vehicle option
  /// Returns Either with Failure or auction ID
  Future<Either<Failure, String>> selectVehicleOption(
      String userId, String externalId);
}
