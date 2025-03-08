import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_auction.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/auction/widgets/auction_basic_info_card.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/auction/widgets/more_details/auction_details_card.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/auction/widgets/auction_feedback_card.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/auction/widgets/auction_price_card.dart';
import 'package:flutter/material.dart';

class AuctionDetailsPage extends StatelessWidget {
  final VehicleAuction auction;

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
              auction: auction,
            ),
            const SizedBox(height: 24),
            AuctionPriceCard(auction: auction),
            const SizedBox(height: 24),
            AuctionFeedbackCard(
              auction: auction,
            ),
            const SizedBox(height: 24),
            AuctionDetailsCard(auction: auction),
          ],
        ),
      ),
    );
  }
}
