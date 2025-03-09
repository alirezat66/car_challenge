import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:vehicle_selection/src/data/models/auction_model.dart';
import 'package:vehicle_selection/vehicle_search.dart';

abstract class SearchLocalDataSource {
  Future<Either<Failure, AuctionModel>> getVehicleAuction();
  Future<void> saveVehicleAuction(Auction auctionModel);
}
