
import 'package:ui_kit/ui_kit.dart';

abstract class NotificationService {
  void showMessage({
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  });
}
