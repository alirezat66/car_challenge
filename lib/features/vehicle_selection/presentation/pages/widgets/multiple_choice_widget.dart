import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_choice.dart';
import 'package:flutter/material.dart';

class MultipleChoicesWidget extends StatelessWidget {
  final List<VehicleChoice> choices;
  final Function(String) onChoiceSelected;

  const MultipleChoicesWidget({
    super.key,
    required this.choices,
    required this.onChoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Multiple vehicles found',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'Please select the correct vehicle from the options below:',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 16),
        ...choices.map((choice) => _buildChoiceCard(context, choice)),
      ],
    );
  }

  Widget _buildChoiceCard(BuildContext context, VehicleChoice choice) {
    // Calculate a color based on similarity percentage
    final Color similarityColor = _getSimilarityColor(choice.similarity);

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
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: similarityColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Match: ${choice.similarity}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => onChoiceSelected(choice.externalId),
                  child: const Text('Select'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSimilarityColor(int similarity) {
    if (similarity >= 80) {
      return Colors.green; // High similarity
    } else if (similarity >= 50) {
      return Colors.orange; // Medium similarity
    } else {
      return Colors.red; // Low similarity
    }
  }
}
