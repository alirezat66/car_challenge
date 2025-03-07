import 'dart:convert';

import 'package:car_challenge/core/constants/pref_keys.dart';
import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/features/user_identification/data/models/user_model.dart';
import 'package:car_challenge/features/vehicle_selection/data/datasources/vehicle_local_data_source.dart';
import 'package:car_challenge/features/vehicle_selection/data/models/vehicle_auction_model.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_auction.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleLocalDataSourceImpl implements VehicleLocalDataSource {
  final SharedPreferences _preferences;

  VehicleLocalDataSourceImpl(SharedPreferences preferences)
      : _preferences = preferences;

  @override
  UserModel? getUser() {
    final userJson = _preferences.getString(userKey);
    return userJson != null ? UserModel.fromJson(jsonDecode(userJson)) : null;
  }

  @override
  Future<Either<Failure, VehicleAuction>> getVehicleAuction() async {
    try {
      final jsonString = _preferences.getString(vehicleAuctionKey);
      if (jsonString == null) {
        return Left(LocalStorageFailure('No cached vehicle auction data'));
      }
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final model = VehicleAuctionModel.fromJson(json);
      return Right(model.toEntity());
    } catch (e) {
      return Left(
          LocalStorageFailure('Error retrieving cached vehicle data: $e'));
    }
  }

  @override
  Future<void> saveVehicleAuction(VehicleAuction auction) async {
    final model = VehicleAuctionModel(
      id: auction.id,
      feedback: auction.feedback,
      valuatedAt: auction.valuatedAt,
      requestedAt: auction.requestedAt,
      createdAt: auction.createdAt,
      updatedAt: auction.updatedAt,
      make: auction.make,
      model: auction.model,
      externalId: auction.externalId,
      fkSellerUser: auction.fkSellerUser,
      price: auction.price,
      positiveCustomerFeedback: auction.positiveCustomerFeedback,
      fkUuidAuction: auction.fkUuidAuction,
      inspectorRequestedAt: auction.inspectorRequestedAt,
      origin: auction.origin,
      estimationRequestId: auction.estimationRequestId,
    );
    await _preferences.setString(vehicleAuctionKey, jsonEncode(model.toJson()));
  }
}
