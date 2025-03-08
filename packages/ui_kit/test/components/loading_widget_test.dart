import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('LoadingWidget', () {
    testWidgets('should display a CircularProgressIndicator',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      // Verify that the CircularProgressIndicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should respect the custom size parameter',
        (WidgetTester tester) async {
      const double customSize = 48.0;

      // Build our app and trigger a frame with custom size
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(size: customSize),
          ),
        ),
      );

      // Find the SizedBox that wraps the CircularProgressIndicator
      final sizedBoxFinder = find.ancestor(
        of: find.byType(CircularProgressIndicator),
        matching: find.byType(SizedBox),
      );

      // Get the SizedBox widget
      final SizedBox sizedBox = tester.widget(sizedBoxFinder);

      // Verify the size
      expect(sizedBox.width, customSize);
      expect(sizedBox.height, customSize);
    });
  });
}
