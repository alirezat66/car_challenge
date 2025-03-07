import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/features/vehicle_selection/data/datasources/vehicle_local_data_source.dart';
import 'package:car_challenge/features/vehicle_selection/data/datasources/vehicle_remote_data_source.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_data.dart';
import 'package:car_challenge/features/vehicle_selection/domain/repositories/vehicle_repository.dart';
import 'package:dartz/dartz.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;
  final VehicleLocalDataSource localDataSource;

  VehicleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, VehicleData>> getVehicleData({
    String? vin,
    String? externalId,
  }) async {
    try {
      // Step 1: Get user ID from local datasource (for Step 2 auth)
      final user = localDataSource.getUser();
      if (user == null) {
        return Left(IdentificationFailure('User not found'));
      }

      try {
        // Step 2: Fetch from RemoteDataSource
        final vehicleData = await remoteDataSource.fetchVehicleData(
          userId: user.id,
          vin: vin,
          externalId: externalId,
        );

        // Step 4 Main Task: Cache if auction data is received (status 200)
        if (vehicleData.auction != null) {
          await localDataSource.saveVehicleAuction(vehicleData.auction!);
        }

        // Return success with either auction (200) or choices (300)
        return Right(vehicleData);
      } on Failure catch (remoteFailure) {
        // Step 4 Bonus Task: On error, try to fetch from cache
        final cachedResult = await localDataSource.getVehicleAuction();
        return cachedResult.fold(
          (cacheFailure) =>
              Left(remoteFailure), // Return original failure if no cache
          (cachedAuction) => Right(VehicleData(auction: cachedAuction)),
        );
      }
    } on Exception catch (e) {
      // Catch unexpected errors not handled by Failure
      return Left(UnknownFailure('Unexpected error in repository: $e'));
    }
  }
}
