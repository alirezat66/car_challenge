import 'package:car_challenge/core/di/service_locator.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/get_user_identification.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/save_identification.dart';
import 'package:car_challenge/features/user_identification/presentation/cubit/user_identification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserIdentificationPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  UserIdentificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserIdentificationCubit(
        locator<SaveUserIdentification>(),
        locator<GetUserIdentification>(),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('User Identification')),
        body: BlocConsumer<UserIdentificationCubit, UserIdentificationState>(
          listener: (context, state) {
            if (state.status == IdentificationStatus.loaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User ID saved: ${state.userId}'),
                ),
              );
            } else if (state.status == IdentificationStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.errorMessage}'),
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Enter User ID'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        context
                            .read<UserIdentificationCubit>()
                            .saveUserId(_controller.text);
                      }
                    },
                    child: const Text('Save'),
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
