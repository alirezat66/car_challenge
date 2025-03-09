import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('AuctionBasicInfoCard', () {
    testWidgets('should display auction info correctly',
        (WidgetTester tester) async {
      const make = 'Toyota';
      const model = 'GT 86';
      const externalId = 'EXT-12345';
      const uuid = 'abcd-1234-5678-efgh';

      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AuctionBasicInfoCard(
              make: make,
              model: model,
              externalId: externalId,
              uuid: uuid,
            ),
          ),
        ),
      );

      // Verify that auction information is displayed correctly
      expect(find.text('$make $model'), findsOneWidget);
      expect(find.text('External ID: $externalId'), findsOneWidget);
      expect(find.text('UUID: $uuid'), findsOneWidget);
    });

    testWidgets('should use correct text styles', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AuctionBasicInfoCard(
              make: 'Toyota',
              model: 'GT 86',
              externalId: 'EXT-12345',
              uuid: 'abcd-1234-5678-efgh',
            ),
          ),
        ),
      );

      // Check that text styles are applied correctly
      final titleFinder = find.text('Toyota GT 86');
      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style, isA<TextStyle>());

      // Verify it's using the headlineMedium style (by checking it against the default theme)
      final BuildContext context = tester.element(titleFinder);
      expect(titleWidget.style,
          equals(Theme.of(context).textTheme.headlineMedium));

      // Check the external ID styling
      final externalIdFinder = find.text('External ID: EXT-12345');
      final externalIdWidget = tester.widget<Text>(externalIdFinder);
      expect(externalIdWidget.style,
          equals(Theme.of(context).textTheme.bodyLarge));

      // Check the UUID styling
      final uuidFinder = find.text('UUID: abcd-1234-5678-efgh');
      final uuidWidget = tester.widget<Text>(uuidFinder);
      expect(uuidWidget.style, equals(Theme.of(context).textTheme.bodySmall));
    });
  });
}
