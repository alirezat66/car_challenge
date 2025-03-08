import 'package:car_challenge/features/vehicle_selection/presentation/cubit/vehicle_selection_cubit.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/search/validator/vin_validation_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> with VinValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final _vinController = TextEditingController();

  @override
  void dispose() {
    _vinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
}
