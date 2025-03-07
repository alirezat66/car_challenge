import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/features/user_identification/data/models/user_model.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_auction.dart';
import 'package:dartz/dartz.dart';

abstract class VehicleLocalDataSource {
  UserModel? getUser();
  Future<Either<Failure, VehicleAuction>> getVehicleAuction();
  Future<void> saveVehicleAuction(VehicleAuction auction);
}
