import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

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
  });
}
