import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:vehicle_selection/src/domain/entities/auction.dart';
import 'package:vehicle_selection/src/presentation/pages/auction/auction_detail_card.dart';

class AuctionDetailsPage extends StatelessWidget {
  final Auction auction;

  const AuctionDetailsPage({super.key, required this.auction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auction Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuctionBasicInfoCard(
              make: auction.make,
              model: auction.model,
              externalId: auction.externalId,
              uuid: auction.fkUuidAuction,
            ),
            const SizedBox(height: 24),
            AuctionPriceCard(
              price: auction.price,
            ),
            const SizedBox(height: 24),
            AuctionFeedbackCard(
              feedback: auction.feedback,
              isPositive: auction.positiveCustomerFeedback,
            ),
            const SizedBox(height: 24),
            AuctionDetailsCard(
              auction: auction,
            ),
          ],
        ),
      ),
    );
  }
}
