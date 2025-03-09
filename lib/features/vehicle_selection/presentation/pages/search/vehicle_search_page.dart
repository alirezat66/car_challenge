import 'package:car_challenge/core/di/service_locator.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/cubit/vehicle_selection_cubit.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/search/factory/vehicle_state_widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VehicleSearchPage extends StatefulWidget {
  
  const VehicleSearchPage({super.key});

  @override
  State<VehicleSearchPage> createState() => _VehicleSearchPageState();
}

class _VehicleSearchPageState extends State<VehicleSearchPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<VehicleSelectionCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Vehicle Selection')),
        body: BlocConsumer<VehicleSelectionCubit, VehicleSelectionState>(
          listener: (context, state) {
            if (state.status == VehicleSelectionStatus.loaded) {
              // Navigate to auction details page using GoRouter
              context.go('/auction_details', extra: state.auction);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: VehicleStateWidgetFactory.build(context, state),
            );
          },
        ),
      ),
    );
  }
}
