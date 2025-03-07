import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_auction.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_choice.dart';
import 'package:equatable/equatable.dart';

class VehicleData extends Equatable {
  final VehicleAuction? auction;
  final List<VehicleChoice>? choices;

  const VehicleData({this.auction, this.choices});

  bool get isValid => (auction != null) ^ (choices != null);

  @override
  List<Object?> get props => [auction, choices];
}
