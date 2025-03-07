import 'dart:convert';

import 'package:car_challenge/features/vehicle_selection/data/models/vehicle_auction_model.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_auction.dart';
import 'package:flutter_test/flutter_test.dart';

final tVehicleAuctionModel = VehicleAuctionModel(
  id: 12345,
  feedback: "Please modify the price.",
  valuatedAt: DateTime.parse("2023-01-05T14:08:40.456Z"),
  requestedAt: DateTime.parse("2023-01-05T14:08:40.456Z"),
  createdAt: DateTime.parse("2023-01-05T14:08:40.456Z"),
  updatedAt: DateTime.parse("2023-01-05T14:08:42.153Z"),
  make: "Toyota",
  model: "GT 86 Basis",
  externalId: "DE003-018601450020008",
  fkSellerUser: "25475e37-6973-483b-9b15-cfee721fc29f",
  price: 800,
  positiveCustomerFeedback: true,
  fkUuidAuction: "3e255ad2-36d4-4048-a962-5e84e27bfa6e",
  inspectorRequestedAt: DateTime.parse("2023-01-05T14:08:40.456Z"),
  origin: "AUCTION",
  estimationRequestId: "3a295387d07f",
);

final Map<String, dynamic> auctionJson = {
  "id": 12345,
  "feedback": "Please modify the price.",
  "valuatedAt": "2023-01-05T14:08:40.456Z",
  "requestedAt": "2023-01-05T14:08:40.456Z",
  "createdAt": "2023-01-05T14:08:40.456Z",
  "updatedAt": "2023-01-05T14:08:42.153Z",
  "make": "Toyota",
  "model": "GT 86 Basis",
  "externalId": "DE003-018601450020008",
  "_fk_sellerUser": "25475e37-6973-483b-9b15-cfee721fc29f",
  "price": 800,
  "positiveCustomerFeedback": true,
  "_fk_uuid_auction": "3e255ad2-36d4-4048-a962-5e84e27bfa6e",
  "inspectorRequestedAt": "2023-01-05T14:08:40.456Z",
  "origin": "AUCTION",
  "estimationRequestId": "3a295387d07f",
};

void main() {
  group('VehicleAuctionModel', () {
    test('should be a subclass of VehicleAuction entity', () {
      // assert
      expect(tVehicleAuctionModel.toEntity(), isA<VehicleAuction>());
    });

    test('should correctly parse from JSON', () {
      // act
      final result = VehicleAuctionModel.fromJson(auctionJson);

      // assert
      expect(result.id, equals(tVehicleAuctionModel.id));
    });

    test('should correctly convert to JSON', () {
      // act
      final result = tVehicleAuctionModel.toJson();

      // assert
      // Using a deep copy comparison since DateTime serialization might affect direct equality
      expect(
          jsonDecode(jsonEncode(result)), jsonDecode(jsonEncode(auctionJson)));
    });
  });
}
