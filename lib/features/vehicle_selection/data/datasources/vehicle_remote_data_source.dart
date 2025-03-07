import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_data.dart';

abstract class VehicleRemoteDataSource {
  Future<VehicleData> getVehicleData({
    required String userId,
    String? vin,
    String? externalId,
  });
}
