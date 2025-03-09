import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('AuctionFeedbackCard', () {
    testWidgets('should display positive feedback correctly',
        (WidgetTester tester) async {
      const String feedback = 'Great car in excellent condition!';
      const bool isPositive = true;

      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AuctionFeedbackCard(
              feedback: feedback,
              isPositive: isPositive,
            ),
          ),
        ),
      );

      // Verify that the header is displayed
      expect(find.text('Customer Feedback'), findsOneWidget);

      // Verify that the feedback text is displayed
      expect(find.text(feedback), findsOneWidget);

      // Verify that the thumbs up icon is displayed for positive feedback
      expect(find.byIcon(Icons.thumb_up), findsOneWidget);
      expect(find.byIcon(Icons.thumb_down), findsNothing);

      // Find the icon and check its color
      final icon = tester.widget<Icon>(find.byIcon(Icons.thumb_up));
      expect(icon.color, equals(Colors.green));
    });

    testWidgets('should display negative feedback correctly',
        (WidgetTester tester) async {
      const String feedback = 'Car has some issues that need attention';
      const bool isPositive = false;

      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AuctionFeedbackCard(
              feedback: feedback,
              isPositive: isPositive,
            ),
          ),
        ),
      );

      // Verify that the feedback text is displayed
      expect(find.text(feedback), findsOneWidget);

      // Verify that the thumbs down icon is displayed for negative feedback
      expect(find.byIcon(Icons.thumb_down), findsOneWidget);
      expect(find.byIcon(Icons.thumb_up), findsNothing);

      // Find the icon and check its color
      final icon = tester.widget<Icon>(find.byIcon(Icons.thumb_down));
      expect(icon.color, equals(Colors.red));
    });

    testWidgets('should handle long feedback text',
        (WidgetTester tester) async {
      const String longFeedback =
          'This is a very long feedback message that should be handled properly by wrapping to multiple lines if needed. The card should expand to accommodate this text without overflowing or causing layout issues.';

      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AuctionFeedbackCard(
              feedback: longFeedback,
              isPositive: true,
            ),
          ),
        ),
      );

      // Verify that the long feedback text is displayed
      expect(find.text(longFeedback), findsOneWidget);

      // No need to check layout constraints - Flutter's layout system will
      // handle text wrapping, but we confirm that the widget renders without errors
    });
  });
}
