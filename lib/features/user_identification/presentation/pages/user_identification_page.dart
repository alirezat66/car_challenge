import 'package:car_challenge/core/di/service_locator.dart';
import 'package:car_challenge/features/user_identification/presentation/cubit/user_identification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:car_challenge/core/widgets/loading_widget.dart';
import 'package:go_router/go_router.dart';

class UserIdentificationPage extends StatefulWidget {
  const UserIdentificationPage({super.key});

  @override
  State<UserIdentificationPage> createState() => _UserIdentificationPageState();
}

class _UserIdentificationPageState extends State<UserIdentificationPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check if user already exists
    // ignore: use_build_context_synchronously
    Future.microtask(() => context.read<UserIdentificationCubit>().loadUser());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<UserIdentificationCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('User Identification')),
        body: BlocConsumer<UserIdentificationCubit, UserIdentificationState>(
          listener: (context, state) {
            if (state.status == IdentificationStatus.loaded) {
              // Navigate to vehicle selection page on successful identification
              context.go('/vehicle_selection');
            } else if (state.status == IdentificationStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.errorMessage}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == IdentificationStatus.loading) {
              return const Center(child: LoadingWidget());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to CarOnSale',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Please enter your unique identifier to continue',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'User ID',
                      hintText: 'Enter your unique identifier',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        context
                            .read<UserIdentificationCubit>()
                            .saveUserId(_controller.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a User ID'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
