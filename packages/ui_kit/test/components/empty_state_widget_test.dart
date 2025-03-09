import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('EmptyStateWidget', () {
    testWidgets('should display title and message',
        (WidgetTester tester) async {
      const String title = 'No Data Available';
      const String message = 'There is no data to display at this time';

      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: title,
              message: message,
            ),
          ),
        ),
      );

      // Verify that the title and message are displayed
      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);

      // Verify that the default icon is displayed
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('should display custom icon when provided',
        (WidgetTester tester) async {
      // Build the widget with custom icon
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'No Items',
              message: 'Your list is empty',
              icon: Icons.shopping_basket,
            ),
          ),
        ),
      );

      // Verify that the custom icon is displayed
      expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsNothing);
    });

    testWidgets('should display action button when provided',
        (WidgetTester tester) async {
      bool buttonPressed = false;
      const String actionText = 'Try Again';

      // Build the widget with action button
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'No Data',
              message: 'Failed to load data',
              actionText: actionText,
              onAction: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      // Verify that the action button is displayed
      expect(find.text(actionText), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Tap the button and verify callback is invoked
      await tester.tap(find.text(actionText));
      expect(buttonPressed, true);
    });

    testWidgets('should not display action button when actionText is null',
        (WidgetTester tester) async {
      // Build the widget without action text
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'No Data',
              message: 'No data available',
              onAction: null, // No action callback
            ),
          ),
        ),
      );

      // Verify that no button is displayed
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('should not display action button when onAction is null',
        (WidgetTester tester) async {
      // Build the widget without action callback
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'No Data',
              message: 'No data available',
              actionText: 'Reload', // We have text but no callback
              onAction: null,
            ),
          ),
        ),
      );

      // Verify that no button is displayed
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('Reload'), findsNothing);
    });
  });
}
