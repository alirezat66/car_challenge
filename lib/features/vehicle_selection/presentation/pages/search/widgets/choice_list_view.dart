import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_choice.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/search/widgets/vehicle_choice_card.dart';
import 'package:flutter/material.dart';

class ChoiceListView extends StatelessWidget {
  final Function(String) onChoiceSelected;

  final List<VehicleChoice> choices;
  const ChoiceListView(
      {super.key, required this.choices, required this.onChoiceSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return VehicleChoiceCard(
          onChoiceSelected: onChoiceSelected,
          choice: choices[index],
        );
      },
      separatorBuilder: (_, __) {
        return const SizedBox(height: 16);
      },
      itemCount: choices.length,
    );
  }
}
