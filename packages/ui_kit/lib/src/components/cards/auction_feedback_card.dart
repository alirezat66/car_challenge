import 'package:flutter/material.dart';

/// Card to display customer feedback about an auction
class AuctionFeedbackCard extends StatelessWidget {
  /// The feedback message
  final String feedback;

  /// Whether the feedback is positive
  final bool isPositive;

  const AuctionFeedbackCard({
    super.key,
    required this.feedback,
    required this.isPositive,
  });

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
                  isPositive ? Icons.thumb_up : Icons.thumb_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    feedback,
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
