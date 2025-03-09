import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('VehicleChoiceCard', () {
    testWidgets('should display vehicle information correctly',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VehicleChoiceCard(
              make: 'Toyota',
              model: 'GT 86',
              description: 'Sports car',
              id: 'ABC123',
              similarity: 75,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Verify that vehicle information is displayed correctly
      expect(find.text('Toyota GT 86'), findsOneWidget);
      expect(find.text('Sports car'), findsOneWidget);
      expect(find.text('ID: ABC123'), findsOneWidget);
      expect(find.text('Match: 75%'), findsOneWidget);

      // Tap the card and verify the callback is invoked
      await tester.tap(find.byType(InkWell));
      expect(tapped, true);
    });

    testWidgets('should use appropriate color based on similarity',
        (WidgetTester tester) async {
      // Test high similarity (green)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VehicleChoiceCard(
              make: 'Toyota',
              model: 'GT 86',
              description: 'Sports car',
              id: 'ABC123',
              similarity: 85,
              onTap: () {},
            ),
          ),
        ),
      );

      // Find the container with the similarity indicator
      final highSimilarityFinder = find.ancestor(
        of: find.text('Match: 85%'),
        matching: find.byType(Container),
      );

      expect(highSimilarityFinder, findsOneWidget);

      final highSimilarityContainer =
          tester.widget<Container>(highSimilarityFinder);
      final highSimilarityDecoration =
          highSimilarityContainer.decoration as BoxDecoration;

      // Green color for high similarity
      expect(highSimilarityDecoration.color, Colors.green);

      // Test low similarity (red)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VehicleChoiceCard(
              make: 'Toyota',
              model: 'GT 86',
              description: 'Sports car',
              id: 'ABC123',
              similarity: 30,
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.pump(); // Make sure UI is updated

      // Find the container with the similarity indicator
      final lowSimilarityFinder = find.ancestor(
        of: find.text('Match: 30%'),
        matching: find.byType(Container),
      );

      expect(lowSimilarityFinder, findsOneWidget);

      final lowSimilarityContainer =
          tester.widget<Container>(lowSimilarityFinder);
      final lowSimilarityDecoration =
          lowSimilarityContainer.decoration as BoxDecoration;

      // Red color for low similarity
      expect(lowSimilarityDecoration.color, Colors.red);
    });
  });
}
