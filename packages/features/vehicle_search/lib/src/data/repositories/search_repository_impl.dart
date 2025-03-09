import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:vehicle_selection/vehicle_search.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final UserDataSource userDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.userDataSource,
  });

  @override
  Future<Either<Failure, SearchResult>> searchByVin(String vin) async {
    try {
      // Get user ID
      final userId = await userDataSource.getUserId();
      if (userId == null) {
        return Left(
            FailureFactory.authenticationFailure('User not authenticated'));
      }

      // Call remote data source which already returns Either<Failure, SearchResult>
      return remoteDataSource.search(userId, vin: vin);
    } catch (e) {
      return Left(FailureFactory.unknownFailure(e));
    }
  }

  @override
  Future<Either<Failure, SearchResult>> selectVehicleOption(
      String externalId) async {
    try {
      // Get user ID
      final userId = await userDataSource.getUserId();
      if (userId == null) {
        return Left(
            FailureFactory.authenticationFailure('User not authenticated'));
      }

      // Call remote data source which already returns Either<Failure, String>
      return remoteDataSource.search(userId, externalId: externalId);
    } catch (e) {
      return Left(FailureFactory.unknownFailure(e));
    }
  }
}
