import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_data.dart';
import 'package:dartz/dartz.dart';

abstract class VehicleRepository {
  Future<Either<Failure, VehicleData>> getVehicleData(
      {String? vin, String? externalId});
}
