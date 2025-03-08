import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class NotificationServiceFactory {
  static NotificationService create(BuildContext context) {
    return SnackBarService(context);
  }
}
