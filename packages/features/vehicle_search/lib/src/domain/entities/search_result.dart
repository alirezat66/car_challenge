// lib/src/domain/entities/search_result.dart
import 'package:equatable/equatable.dart';
import 'package:vehicle_selection/src/domain/entities/auction.dart';
import 'vehicle_choice.dart';

class SearchResult extends Equatable {
  final Auction? auction;
  final List<VehicleChoice>? choices;

  const SearchResult({this.auction, this.choices});

  bool get isValid => (auction != null) ^ (choices != null);

  @override
  List<Object?> get props => [auction, choices];
}
