import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_auction.dart';
import 'package:flutter/material.dart';

class AuctionFeedbackCard extends StatelessWidget {
  final VehicleAuction auction;
  const AuctionFeedbackCard({super.key, required this.auction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Feedback',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  auction.positiveCustomerFeedback
                      ? Icons.thumb_up
                      : Icons.thumb_down,
                  color: auction.positiveCustomerFeedback
                      ? Colors.green
                      : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    auction.feedback,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
