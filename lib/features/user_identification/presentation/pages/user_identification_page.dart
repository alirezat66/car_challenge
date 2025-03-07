import 'package:car_challenge/core/di/service_locator.dart';
import 'package:car_challenge/core/notification/notification_service.dart';
import 'package:car_challenge/core/notification/notification_type.dart';
import 'package:car_challenge/core/theme/theme_extension.dart';
import 'package:car_challenge/features/user_identification/presentation/cubit/user_identification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:car_challenge/core/widgets/loading_widget.dart';
import 'package:go_router/go_router.dart';

class UserIdentificationPage extends StatefulWidget {
  final NotificationService notificationService;

  const UserIdentificationPage({super.key, required this.notificationService});

  @override
  State<UserIdentificationPage> createState() => _UserIdentificationPageState();
}

class _UserIdentificationPageState extends State<UserIdentificationPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<UserIdentificationCubit>()..loadUser(),
      child: Scaffold(
        appBar: AppBar(title: const Text('User Identification')),
        body: BlocConsumer<UserIdentificationCubit, UserIdentificationState>(
          listener: (context, state) {
            if (state.status == IdentificationStatus.loaded) {
              // Navigate to vehicle selection page on successful identification
              context.go('/vehicle_selection');
            } else if (state.status == IdentificationStatus.error) {
              widget.notificationService.showMessage(
                  message: 'Error: ${state.errorMessage}',
                  type: NotificationType.error);
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
                  Text(
                    'Welcome to CarOnSale',
                    style: context.headlineSmall
                        .copyWith(fontWeight: FontWeight.bold),
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
                    onPressed: state.status == IdentificationStatus.loading
                        ? null
                        : () {
                            if (_controller.text.isNotEmpty) {
                              context
                                  .read<UserIdentificationCubit>()
                                  .saveUserId(_controller.text);
                            } else {
                              widget.notificationService.showMessage(
                                  message: 'Please enter a User ID',
                                  type: NotificationType.error);
                            }
                          },
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
