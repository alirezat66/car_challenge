import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:vehicle_selection/src/domain/entities/search_result.dart';

abstract class SearchRemoteDataSource {
  Future<Either<Failure, SearchResult>> search(String userId,
      {String? vin, String? externalId});
}
