import 'package:vehicle_selection/src/domain/entities/auction.dart';

class AuctionModel {
  final int id;
  final String feedback;
  final DateTime valuatedAt;
  final DateTime requestedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String make;
  final String model;
  final String externalId;
  final String fkSellerUser;
  final int price;
  final bool positiveCustomerFeedback;
  final String fkUuidAuction;
  final DateTime inspectorRequestedAt;
  final String origin;
  final String estimationRequestId;

  AuctionModel({
    required this.id,
    required this.feedback,
    required this.valuatedAt,
    required this.requestedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.make,
    required this.model,
    required this.externalId,
    required this.fkSellerUser,
    required this.price,
    required this.positiveCustomerFeedback,
    required this.fkUuidAuction,
    required this.inspectorRequestedAt,
    required this.origin,
    required this.estimationRequestId,
  });

  factory AuctionModel.fromJson(Map<String, dynamic> json) {
    return AuctionModel(
      id: json['id'] as int,
      feedback: json['feedback'] as String,
      valuatedAt: DateTime.parse(json['valuatedAt'] as String),
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      make: json['make'] as String,
      model: json['model'] as String,
      externalId: json['externalId'] as String,
      fkSellerUser: json['_fk_sellerUser'] as String,
      price: json['price'] as int,
      positiveCustomerFeedback: json['positiveCustomerFeedback'] as bool,
      fkUuidAuction: json['_fk_uuid_auction'] as String,
      inspectorRequestedAt:
          DateTime.parse(json['inspectorRequestedAt'] as String),
      origin: json['origin'] as String,
      estimationRequestId: json['estimationRequestId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feedback': feedback,
      'valuatedAt': valuatedAt.toIso8601String(),
      'requestedAt': requestedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'make': make,
      'model': model,
      'externalId': externalId,
      '_fk_sellerUser': fkSellerUser,
      'price': price,
      'positiveCustomerFeedback': positiveCustomerFeedback,
      '_fk_uuid_auction': fkUuidAuction,
      'inspectorRequestedAt': inspectorRequestedAt.toIso8601String(),
      'origin': origin,
      'estimationRequestId': estimationRequestId,
    };
  }

  Auction toEntity() {
    return Auction(
      id: id,
      feedback: feedback,
      valuatedAt: valuatedAt,
      requestedAt: requestedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      make: make,
      model: model,
      externalId: externalId,
      fkSellerUser: fkSellerUser,
      price: price,
      positiveCustomerFeedback: positiveCustomerFeedback,
      fkUuidAuction: fkUuidAuction,
      inspectorRequestedAt: inspectorRequestedAt,
      origin: origin,
      estimationRequestId: estimationRequestId,
    );
  }

  factory AuctionModel.fromEntity(Auction auction) {
    return AuctionModel(
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
  }
}
