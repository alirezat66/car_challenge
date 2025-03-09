import 'dart:convert';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:vehicle_selection/src/data/data_sources/search_local_data_source.dart';
import 'package:vehicle_selection/src/data/models/auction_model.dart';
import 'package:vehicle_selection/vehicle_search.dart';

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final LocalStorage _storage;

  SearchLocalDataSourceImpl(LocalStorage storage) : _storage = storage;

  @override
  Future<Either<Failure, AuctionModel>> getVehicleAuction() async {
    try {
      final jsonString =
          await _storage.getString(StorageKeys.vehicleAuctionKey);
      if (jsonString == null) {
        return Left(LocalStorageFailure('No cached vehicle auction data'));
      }
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final model = AuctionModel.fromJson(json);
      return Right(model);
    } catch (e) {
      return Left(
          LocalStorageFailure('Error retrieving cached vehicle data: $e'));
    }
  }

  @override
  Future<void> saveVehicleAuction(Auction auction) async {
   

    await _storage.saveString(
        StorageKeys.vehicleAuctionKey, jsonEncode( AuctionModel.fromEntity(auction).toJson()));
  }
}
