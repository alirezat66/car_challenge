import 'package:car_challenge/core/theme/theme_extension.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/extension/similarity_extension.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_choice.dart';
import 'package:flutter/material.dart';

class VehicleChoiceCard extends StatelessWidget {
  final VehicleChoice choice;
  final Function(String) onChoiceSelected;
  const VehicleChoiceCard(
      {super.key, required this.onChoiceSelected, required this.choice});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () => onChoiceSelected(choice.externalId),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${choice.make} ${choice.model}',
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
                        color: choice.similarity.similarityColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Match: ${choice.similarity}%',
                          style: context.titleMedium),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  choice.containerName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'ID: ${choice.externalId}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ));
  }
}
