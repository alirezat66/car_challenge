import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class IdentificationForm extends StatefulWidget {
  final NotificationService notificationService;
  final Function(String) onSubmit;

  const IdentificationForm({
    super.key,
    required this.notificationService,
    required this.onSubmit,
  });

  @override
  State<IdentificationForm> createState() => _IdentificationFormState();
}

class _IdentificationFormState extends State<IdentificationForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_controller.text.isNotEmpty) {
      widget.onSubmit(_controller.text);
    } else {
      widget.notificationService.showMessage(
        message: 'Please enter a User ID',
        type: NotificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'User ID',
              hintText: 'Enter your unique identifier',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleSubmit(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleSubmit,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
