import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/src/components/lists/choice_list_view.dart';

// Mock model for testing
class TestItem {
  final String title;
  final String subtitle;

  TestItem(this.title, this.subtitle);
}

void main() {
  group('ChoiceListView', () {
    final List<TestItem> testItems = [
      TestItem('Item 1', 'Description 1'),
      TestItem('Item 2', 'Description 2'),
      TestItem('Item 3', 'Description 3'),
    ];

    Widget testItemBuilder(BuildContext context, TestItem item) {
      return ListTile(
        title: Text(item.title),
        subtitle: Text(item.subtitle),
      );
    }

    testWidgets('should render all items using itemBuilder',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChoiceListView<TestItem>(
              items: testItems,
              itemBuilder: testItemBuilder,
            ),
          ),
        ),
      );

      // Verify that all items are rendered
      for (var item in testItems) {
        expect(find.text(item.title), findsOneWidget);
        expect(find.text(item.subtitle), findsOneWidget);
      }

      // Verify we have the correct number of list tiles
      expect(find.byType(ListTile), findsNWidgets(testItems.length));
    });

    testWidgets('should use specified spacing between items',
        (WidgetTester tester) async {
      const double customSpacing = 24.0;

      // Build the widget with custom spacing
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChoiceListView<TestItem>(
              items: testItems,
              itemBuilder: testItemBuilder,
              spacing: customSpacing,
            ),
          ),
        ),
      );

      // Find SizedBox separators
      final separators =
          tester.widgetList<SizedBox>(find.byType(SizedBox)).toList();

      // Verify we have correct number of separators (items.length - 1)
      expect(separators.length, testItems.length - 1);

      // Verify each separator has the correct height
      for (var separator in separators) {
        expect(separator.height, equals(customSpacing));
      }
    });

    testWidgets('should handle empty items list', (WidgetTester tester) async {
      // Build the widget with an empty list
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChoiceListView<TestItem>(
              items: [], // Empty list
              itemBuilder: testItemBuilder,
            ),
          ),
        ),
      );

      // Verify that no items are rendered
      expect(find.byType(ListTile), findsNothing);
      expect(find.byType(SizedBox), findsNothing);
    });

    testWidgets('should use ListView.separated internally',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChoiceListView<TestItem>(
              items: testItems,
              itemBuilder: testItemBuilder,
            ),
          ),
        ),
      );

      // Verify that it uses ListView.separated internally
      // We can't directly test for ListView.separated, but we can check
      // that it renders both items and separators correctly
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(testItems.length));
      expect(find.byType(SizedBox), findsNWidgets(testItems.length - 1));
    });
  });
}
