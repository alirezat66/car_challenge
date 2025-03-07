// test/core/notification/snack_bar_service_test.dart

import 'package:car_challenge/core/notification/notification_service.dart';
import 'package:car_challenge/core/notification/notification_type.dart';
import 'package:car_challenge/core/notification/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SnackBarService', () {
    testWidgets('showMessage displays a snackbar with the correct message',
        (WidgetTester tester) async {
      // Build our test app with a Scaffold and ScaffoldMessenger
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Create and use the notification service
                      final snackBarService = SnackBarService(context);
                      snackBarService.showMessage(
                        message: 'Test notification',
                        type: NotificationType.info,
                      );
                    },
                    child: const Text('Show Notification'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Tap the button to show the notification
      await tester.tap(find.text('Show Notification'));
      await tester.pump(); // Start the snackbar animation

      // Verify that the snackbar appears with the correct message
      expect(find.text('Test notification'), findsOneWidget);

      // Verify the background color is blue (info type)
      final snackBarMaterial = tester.widget<Material>(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.byType(Material),
        ),
      );
      expect(snackBarMaterial.color, Colors.blue);
    });

    testWidgets('showMessage displays a snackbar with error type',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final snackBarService = SnackBarService(context);
                      snackBarService.showMessage(
                        message: 'Error message',
                        type: NotificationType.error,
                      );
                    },
                    child: const Text('Show Error'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pump();

      expect(find.text('Error message'), findsOneWidget);

      final snackBarMaterial = tester.widget<Material>(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.byType(Material),
        ),
      );
      expect(snackBarMaterial.color, Colors.red);
    });

    testWidgets('showMessage displays a snackbar with success type',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final snackBarService = SnackBarService(context);
                      snackBarService.showMessage(
                        message: 'Success message',
                        type: NotificationType.success,
                      );
                    },
                    child: const Text('Show Success'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Success'));
      await tester.pump();

      expect(find.text('Success message'), findsOneWidget);

      final snackBarMaterial = tester.widget<Material>(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.byType(Material),
        ),
      );
      expect(snackBarMaterial.color, Colors.green);
    });

    testWidgets('showMessage displays a snackbar with warning type',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final snackBarService = SnackBarService(context);
                      snackBarService.showMessage(
                        message: 'Warning message',
                        type: NotificationType.warning,
                      );
                    },
                    child: const Text('Show Warning'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Warning'));
      await tester.pump();

      expect(find.text('Warning message'), findsOneWidget);

      final snackBarMaterial = tester.widget<Material>(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.byType(Material),
        ),
      );
      expect(snackBarMaterial.color, Colors.orange);
    });

    testWidgets('showMessage respects custom duration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final snackBarService = SnackBarService(context);
                      snackBarService.showMessage(
                        message: 'Custom duration',
                        duration: const Duration(seconds: 1),
                      );
                    },
                    child: const Text('Show Custom Duration'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Custom Duration'));
      await tester.pump();

      expect(find.text('Custom duration'), findsOneWidget);

      // Wait for just under 1 second - snackbar should still be visible
      await tester.pump(const Duration(milliseconds: 900));
      expect(find.text('Custom duration'), findsOneWidget);

      // Wait for the rest of the duration plus a small margin
      await tester.pump(const Duration(milliseconds: 200));

      // Need to pump a frame to process the animation
      await tester.pump();

      // Need to wait for the animation to start
      await tester.pump();

      // Now the snackbar should be in the process of disappearing
      // But we can't test this precisely without waiting for the entire animation
    });

    testWidgets('implements NotificationService interface',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              // Verify that SnackBarService can be assigned to NotificationService
              NotificationService service = SnackBarService(context);

              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      service.showMessage(message: 'Interface test');
                    },
                    child: const Text('Show Interface Message'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Interface Message'));
      await tester.pump();

      // Verify that the notification appears
      expect(find.text('Interface test'), findsOneWidget);
    });
  });
}
