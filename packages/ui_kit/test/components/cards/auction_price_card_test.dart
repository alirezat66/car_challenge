import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('AuctionPriceCard', () {
    testWidgets('should display price correctly with default currency',
        (WidgetTester tester) async {
      const int price = 12500;

      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AuctionPriceCard(
              price: price,
            ),
          ),
        ),
      );

      // Verify that the header is displayed
      expect(find.text('Price Information'), findsOneWidget);
      
      // Verify that the price is displayed with the default currency (€)
      expect(find.text('€$price'), findsOneWidget);
    });

    testWidgets('should display price with custom currency',
        (WidgetTester tester) async {
      const int price = 12500;
      const String currency = '\$';

      // Build the widget with custom currency
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AuctionPriceCard(
              price: price,
              currency: currency,
            ),
          ),
        ),
      );

      // Verify that the price is displayed with the custom currency
      expect(find.text('$currency$price'), findsOneWidget);
    });

    testWidgets('should use theme primary color for price container',
        (WidgetTester tester) async {
      // Define a custom theme with specific primary color
      final customTheme = ThemeData.light().copyWith(
        primaryColor: Colors.purple,
      );

      // Build the widget with custom theme
      await tester.pumpWidget(
        MaterialApp(
          theme: customTheme,
          home: const Scaffold(
            body: AuctionPriceCard(
              price: 12500,
            ),
          ),
        ),
      );

      // Find the container that displays the price
      final priceFinder = find.text('€12500');
      final containerFinder = find.ancestor(
        of: priceFinder, 
        matching: find.byType(Container),
      );
      
      // Get the container and its decoration
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      
      // Verify the container uses the theme's primary color
      expect(decoration.color, equals(customTheme.primaryColor));
    });
  });
}