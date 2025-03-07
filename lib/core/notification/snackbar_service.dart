import 'package:car_challenge/core/notification/notification_service.dart';
import 'package:car_challenge/core/notification/notification_type.dart';
import 'package:flutter/material.dart';

class SnackBarService implements NotificationService {
  final BuildContext context;

  const SnackBarService(this.context);

  @override
  void showMessage({
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _getBackgroundColor(type),
        duration: duration,
      ),
    );
  }

  /// Get background color based on notification type
  Color _getBackgroundColor(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.success:
        return Colors.green;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.warning:
        return Colors.orange;
    }
  }
}
