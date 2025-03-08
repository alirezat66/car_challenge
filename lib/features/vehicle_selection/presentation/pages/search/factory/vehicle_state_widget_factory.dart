import 'package:car_challenge/core/widgets/error_display_widget.dart';
import 'package:car_challenge/core/widgets/loading_widget.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/cubit/vehicle_selection_cubit.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/search/multiple_choice_view.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/search/search_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleStateWidgetFactory {
  static Widget build(BuildContext context, VehicleSelectionState state) {
    switch (state.status) {
      case VehicleSelectionStatus.initial:
        return const SearchForm();
      case VehicleSelectionStatus.loading:
        return const LoadingWidget(size: 40);
      case VehicleSelectionStatus.error:
        return ErrorDisplayWidget(
          errorMessage: state.errorMessage,
          onAction: () {
            context.read<VehicleSelectionCubit>().retry();
          },
        );
      case VehicleSelectionStatus.multipleChoices:
        return MultipleChoicesView(
          choices: state.choices ?? [],
          onChoiceSelected: (externalId) {
            context.read<VehicleSelectionCubit>().selectVehicle(externalId);
          },
        );
      case VehicleSelectionStatus.loaded:
        return const SizedBox();
    }
  }
}
