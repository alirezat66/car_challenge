import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/core/usecase/usecase.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle.dart';
import 'package:car_challenge/features/vehicle_selection/domain/repositories/vehicle_repository.dart';
import 'package:dartz/dartz.dart';

class GetVehicleData implements UseCase<List<Vehicle>, String> {
  final VehicleRepository repository;

  GetVehicleData(this.repository);

  @override
  Future<Either<Failure, List<Vehicle>>> call(String vin) async {
    return await repository.fetchVehiclesByVin(vin);
  }
}
