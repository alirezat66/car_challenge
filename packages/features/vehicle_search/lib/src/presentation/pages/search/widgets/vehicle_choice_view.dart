// lib/src/presentation/widgets/multiple_choice_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';
import '../../../../domain/entities/vehicle_choice.dart';
import '../../../cubit/search_cubit.dart';

class VehicleCarChoiceView extends StatelessWidget {
  final List<VehicleChoice> choices;

  const VehicleCarChoiceView({
    super.key,
    required this.choices,
  });

  @override
  Widget build(BuildContext context) {
    return MultipleChoicesView<VehicleChoice>(
      title: 'Multiple Matches Found',
      description: 'Please select the correct vehicle from the options below.',
      choices: choices,
      itemBuilder: (context, choice) => VehicleChoiceCard(
        make: choice.make,
        model: choice.model,
        description: choice.containerName,
        id: choice.externalId,
        similarity: choice.similarity,
        onTap: () {
          context.read<SearchCubit>().selectVehicle(choice.externalId);
        },
      ),
    );
  }
}
