import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../entities/search_result.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResult>> searchByVin(String vin);
  Future<Either<Failure, SearchResult>> selectVehicleOption(String externalId);
}
