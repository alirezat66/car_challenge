import 'package:car_challenge/core/notification/notification_service.dart';
import 'package:car_challenge/core/notification/snackbar_service.dart';
import 'package:flutter/material.dart';

class NotificationServiceFactory {
  static NotificationService create(BuildContext context) {
    return SnackBarService(context);
  }
}
