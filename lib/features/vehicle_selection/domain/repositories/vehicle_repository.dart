
import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle.dart';
import 'package:dartz/dartz.dart';

abstract class VehicleRepository {
  Future<Either<Failure, List<Vehicle>>> fetchVehiclesByVin(String vin);
  Future<Either<Failure, Vehicle>> selectVehicle(
      String vin, List<Vehicle> vehicles);
}
