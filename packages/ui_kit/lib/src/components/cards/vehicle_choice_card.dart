import 'package:flutter/material.dart';
import 'package:ui_kit/src/extension/similarity_ext.dart';
import 'package:ui_kit/ui_kit.dart';

/// Card displaying a vehicle choice with similarity indicator
class VehicleChoiceCard extends StatelessWidget {
  /// Vehicle make (manufacturer)
  final String make;

  /// Vehicle model
  final String model;

  /// Description of the vehicle
  final String description;

  /// Vehicle ID
  final String id;

  /// Similarity percentage (0-100)
  final int similarity;

  /// Callback when the card is selected
  final VoidCallback onTap;

  const VehicleChoiceCard({
    super.key,
    required this.make,
    required this.model,
    required this.description,
    required this.id,
    required this.similarity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$make $model',
                      style: context.titleMedium
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: similarity.similarityColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Match: $similarity%',
                        style: context.titleMedium.copyWith(
                          color: similarity > 50 ? Colors.white : Colors.black,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'ID: $id',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
