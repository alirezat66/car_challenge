import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('ErrorDisplayWidget', () {
    testWidgets('should display error message and retry button',
        (WidgetTester tester) async {
      const errorMessage = 'Test error message';
      bool retryPressed = false;

      // Build our app and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(
              errorMessage: errorMessage,
              onAction: () {
                retryPressed = true;
              },
            ),
          ),
        ),
      );

      // Verify that the error icon is displayed
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      // Verify that the error message is displayed
      expect(find.text(errorMessage), findsOneWidget);

      // Verify that the error title is displayed
      expect(find.text('Error'), findsOneWidget);

      // Verify that the retry button is displayed
      expect(find.text('Retry'), findsOneWidget);

      // Tap the retry button and verify the callback is invoked
      await tester.tap(find.text('Retry'));
      expect(retryPressed, true);
    });

    testWidgets('should display solution when provided',
        (WidgetTester tester) async {
      const errorMessage = 'Test error message';
      const solution = 'Test solution message';

      // Build our app and trigger a frame with solution
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(
              errorMessage: errorMessage,
              solution: solution,
            ),
          ),
        ),
      );

      // Verify that the solution is displayed
      expect(find.text(solution), findsOneWidget);
    });
  });
}
