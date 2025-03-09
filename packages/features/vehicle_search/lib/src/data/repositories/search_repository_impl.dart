import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:vehicle_selection/src/data/data_sources/search_local_data_source.dart';
import 'package:vehicle_selection/vehicle_search.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;
  final UserDataSource userDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.userDataSource,
  });

  @override
  Future<Either<Failure, SearchResult>> search(
      {String? vin, String? externalId}) async {
    try {
      // Get user ID
      final userId = await userDataSource.getUserId();
      if (userId == null) {
        return Left(
            FailureFactory.authenticationFailure('User not authenticated'));
      }

      try {
        // Step 2: Fetch from RemoteDataSource
        final remoteResult = await remoteDataSource.search(
          userId,
          vin: vin,
        );

        // Step 4 Main Task: Cache if auction data is received (status 200)
        return await remoteResult.fold(
          (failure) =>
              _getInfoFromCache(failure), // Failure: Check cache, no saving
          (success) => _saveAndReturn(success), // Success: Save and return
        );
      } on Failure catch (remoteFailure) {
        // Step 4 Bonus Task: On error, try to fetch from cache
        return _getInfoFromCache(FailureFactory.unknownFailure(remoteFailure));
      }
    } catch (e) {
      return Left(FailureFactory.unknownFailure(e));
    }
  }

  Future<Either<Failure, SearchResult>> _getInfoFromCache(
      Failure originalFailure) async {
    final cachedResult = await localDataSource.getVehicleAuction();
    return cachedResult.fold(
      (cacheFailure) =>
          Left(originalFailure), // Cache failed, return original failure
      (cachedAuction) => Right(
          SearchResult(auction: cachedAuction.toEntity())), // Cache success
    );
  }

  Future<Either<Failure, SearchResult>> _saveAndReturn(
      SearchResult success) async {
    if (success.auction != null) {
      await localDataSource
          .saveVehicleAuction(success.auction!); // Save only on success
    }
    return Right(success);
  }
}
