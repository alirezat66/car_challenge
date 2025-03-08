import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_choice.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/search/widgets/choice_list_view.dart';
import 'package:flutter/material.dart';

class MultipleChoicesView extends StatelessWidget {
  final List<VehicleChoice> choices;
  final Function(String) onChoiceSelected;

  const MultipleChoicesView({
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
        const SizedBox(height: 8),
        Expanded(
          child: ChoiceListView(
            choices: choices,
            onChoiceSelected: onChoiceSelected,
          ),
        ),
      ],
    );
  }
}
