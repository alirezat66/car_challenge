import 'package:flutter/material.dart';

/// Card to display basic information about an auction item
class AuctionBasicInfoCard extends StatelessWidget {
  /// Make of vehicle (manufacturer)
  final String make;

  /// Model of vehicle
  final String model;

  /// External ID of the item
  final String externalId;

  /// UUID of the auction
  final String uuid;

  const AuctionBasicInfoCard({
    super.key,
    required this.make,
    required this.model,
    required this.externalId,
    required this.uuid,
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
              '$make $model',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'External ID: $externalId',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'UUID: $uuid',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
