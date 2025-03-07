import 'package:car_challenge/core/di/service_locator.dart';
import 'package:car_challenge/core/widgets/error_display_widget.dart';
import 'package:car_challenge/core/widgets/loading_widget.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/cubit/vehicle_selection_cubit.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/widgets/multiple_choice_widget.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/validator/vin_validation_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VehicleSelectionPage extends StatefulWidget {
  const VehicleSelectionPage({super.key});

  @override
  State<VehicleSelectionPage> createState() => _VehicleSelectionPageState();
}

class _VehicleSelectionPageState extends State<VehicleSelectionPage>
    with VinValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final _vinController = TextEditingController();

  @override
  void dispose() {
    _vinController.dispose();
    super.dispose();
  }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildForm(context),
                  const SizedBox(height: 24),
                  _buildStateBasedContent(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _vinController,
            decoration: const InputDecoration(
              labelText: 'Vehicle Identification Number (VIN)',
              hintText: 'Enter 17-character VIN',
            ),
            validator: validateVin,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                context
                    .read<VehicleSelectionCubit>()
                    .submitVin(_vinController.text);
              }
            },
            child: const Text('Search Vehicle'),
          ),
        ],
      ),
    );
  }

  Widget _buildStateBasedContent(
      BuildContext context, VehicleSelectionState state) {
    switch (state.status) {
      case VehicleSelectionStatus.loading:
        return const LoadingWidget(size: 40);

      case VehicleSelectionStatus.error:
        return ErrorDisplayWidget(
          errorMessage: state.errorMessage,
          onRetry: () {
            if (_formKey.currentState?.validate() ?? false) {
              context
                  .read<VehicleSelectionCubit>()
                  .submitVin(_vinController.text);
            }
          },
        );

      case VehicleSelectionStatus.multipleChoices:
        return MultipleChoicesWidget(
          choices: state.choices ?? [],
          onChoiceSelected: (externalId) {
            context.read<VehicleSelectionCubit>().selectVehicle(externalId);
          },
        );

      case VehicleSelectionStatus.initial:
      case VehicleSelectionStatus.loaded:
        return const SizedBox(); // No additional content needed
    }
  }
}
