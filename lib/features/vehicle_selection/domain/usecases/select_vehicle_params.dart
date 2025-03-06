import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/core/usecase/usecase.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle.dart';
import 'package:car_challenge/features/vehicle_selection/domain/repositories/vehicle_repository.dart';
import 'package:dartz/dartz.dart';

class SelectVehicleParams {
  final String vin;
  final List<Vehicle> vehicles;

  SelectVehicleParams(this.vin, this.vehicles);
}

class SelectVehicle implements UseCase<Vehicle, SelectVehicleParams> {
  final VehicleRepository repository;

  SelectVehicle(this.repository);

  @override
  Future<Either<Failure, Vehicle>> call(SelectVehicleParams params) async {
    return await repository.selectVehicle(params.vin, params.vehicles);
  }
}
