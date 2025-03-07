import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_auction.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_choice.dart';

class VehicleData {
  final VehicleAuction? auction;
  final List<VehicleChoice>? choices;

  VehicleData({this.auction, this.choices});

  bool get isValid => (auction != null) ^ (choices != null);
}
