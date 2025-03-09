// lib/src/presentation/widgets/vin_input_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';
import '../../cubit/search_cubit.dart';

class VinInputForm extends StatefulWidget {
  const VinInputForm({super.key});

  @override
  State<VinInputForm> createState() => _VinInputFormState();
}

class _VinInputFormState extends State<VinInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _vinController = TextEditingController();
  static const int vinLength = 17; // Standard VIN length

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter Vehicle Identification Number',
            style: context.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _vinController,
            decoration: const InputDecoration(
              labelText: 'VIN',
              hintText: 'Enter 17-character VIN',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
            textCapitalization: TextCapitalization.characters,
            validator: _validateVin,
            onFieldSubmitted: (_) => _submitForm(),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _submitForm,
            icon: const Icon(Icons.search),
            label: const Text('Search Vehicle'),
          ),
        ],
      ),
    );
  }

  String? _validateVin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a VIN';
    }
    if (value.length != vinLength) {
      return 'VIN must be exactly $vinLength characters';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context
          .read<SearchCubit>()
          .searchByVin(_vinController.text.toUpperCase());
    }
  }
}
