import 'package:car_challenge/core/notification/notification_type.dart';

abstract class NotificationService {
  void showMessage({
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  });
}
