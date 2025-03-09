import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:user_identification/src/presentation/pages/identification_form.dart';
import 'package:user_identification/user_identification.dart';

class UserIdentificationPage extends StatelessWidget {
  final NotificationService notificationService;
  final VoidCallback? onUserIdentified;

  const UserIdentificationPage({
    super.key,
    required this.notificationService,
    this.onUserIdentified,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Identification'),
      ),
      body: BlocConsumer<UserIdentificationCubit, UserIdentificationState>(
        listener: (context, state) {
          if (state.status == IdentificationStatus.loaded) {
            // Notify that user is identified
            onUserIdentified?.call();
          } else if (state.status == IdentificationStatus.error) {
            // Show error notification
            notificationService.showMessage(
              message: state.errorMessage,
              type: NotificationType.error,
            );
          }
        },
        builder: (context, state) {
          // Try to load user when the page initializes
          if (state.status == IdentificationStatus.initial) {
            // Initialize user loading
            _initUserLoading(context);
          }

          // Show loading indicator when loading
          if (state.status == IdentificationStatus.loading) {
            return const Center(child: LoadingWidget());
          }

          // Show the user input form
          return Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Welcome to CarOnSale',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
              IdentificationForm(
                notificationService: notificationService,
                onSubmit: (userId) {
                  context.read<UserIdentificationCubit>().saveUserId(userId);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _initUserLoading(BuildContext context) {
    // Use a post-frame callback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserIdentificationCubit>().loadUser();
    });
  }
}
