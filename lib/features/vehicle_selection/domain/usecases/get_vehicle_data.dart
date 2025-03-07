import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/core/usecase/usecase.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_data.dart';
import 'package:car_challenge/features/vehicle_selection/domain/repositories/vehicle_repository.dart';
import 'package:dartz/dartz.dart';

class GetVehicleData implements UseCase<VehicleData, GetVehicleDataParams> {
  final VehicleRepository repository;

  GetVehicleData(this.repository);

  @override
  Future<Either<Failure, VehicleData>> call(GetVehicleDataParams params) {
    return repository.getVehicleData(
      vin: params.vin,
      externalId: params.externalId,
    );
  }
}

class GetVehicleDataParams {
  final String? vin;
  final String? externalId;

  GetVehicleDataParams({
    this.vin,
    this.externalId,
  });
}
