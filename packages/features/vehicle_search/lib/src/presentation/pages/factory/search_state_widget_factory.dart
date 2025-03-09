import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:vehicle_selection/src/presentation/cubit/search_cubit.dart';
import 'package:vehicle_selection/src/presentation/pages/search/widgets/vehicle_choice_view.dart';
import 'package:vehicle_selection/src/presentation/pages/search/widgets/vin_input_form.dart';

class SearchStateWidgetFactory {
  static Widget build(BuildContext context, SearchState state) {
    switch (state.status) {
      case SearchStatus.initial:
        return const VinInputForm();
      case SearchStatus.loading:
        return const LoadingWidget(size: 40);
      case SearchStatus.error:
        return ErrorDisplayWidget(
          errorMessage: state.errorMessage,
          onAction: () {
            context.read<SearchCubit>().retry();
          },
        );
      case SearchStatus.multipleChoices:
        return VehicleCarChoiceView(
          choices: state.choices ?? [],
        );
      case SearchStatus.loaded:
        return const SizedBox();
    }
  }
}
