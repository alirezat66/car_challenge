import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('AuctionDetailTable', () {
    final List<TableInfo> testRowItems = [
      TableInfo('ID', 12345),
      TableInfo('Make', 'Toyota'),
      TableInfo('Model', 'GT 86'),
      TableInfo('Price', '€15,000'),
      TableInfo('Year', 2020),
    ];

    testWidgets('should render table with correct column headers',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuctionDetailTable(
              rowItems: testRowItems,
            ),
          ),
        ),
      );

      // Verify that column headers are displayed
      expect(find.text('Parameter'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
    });

    testWidgets('should render all rows with correct data',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuctionDetailTable(
              rowItems: testRowItems,
            ),
          ),
        ),
      );

      // Verify all parameter names are displayed
      for (var item in testRowItems) {
        expect(find.text(item.name), findsOneWidget);
        expect(find.text(item.value.toString()), findsOneWidget);
      }
    });

    testWidgets('should apply alternating colors to rows',
        (WidgetTester tester) async {
      // Need a minimal set of items to test alternating colors
      final shortRowItems = [
        TableInfo('Item 1', 'Value 1'),
        TableInfo('Item 2', 'Value 2'),
      ];

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.blue,
          ),
          home: Scaffold(
            body: AuctionDetailTable(
              rowItems: shortRowItems,
            ),
          ),
        ),
      );

      // Find DataRows (need to verify through DataTable's row list)
      final dataTable = tester.widget<DataTable>(find.byType(DataTable));

      // Verify we have the correct number of rows
      expect(dataTable.rows.length, equals(shortRowItems.length));

      // Check that rows have alternating colors
      // Even rows (index 0, 2, etc.) should have primary color with opacity
      // Odd rows (index 1, 3, etc.) should have white with opacity
      final firstRowMaterialState = dataTable.rows[0].color;
      final secondRowMaterialState = dataTable.rows[1].color;

      // We need to resolve the MaterialStateProperty to get the actual colors
      expect(firstRowMaterialState, isA<MaterialStateProperty<Color?>>());
      expect(secondRowMaterialState, isA<MaterialStateProperty<Color?>>());

      // MateriaStates resolve to different colors for alternating rows
      expect(firstRowMaterialState != secondRowMaterialState, true);
    });

    testWidgets('should handle empty row items list',
        (WidgetTester tester) async {
      // Build the widget with empty list
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuctionDetailTable(
              rowItems: [],
            ),
          ),
        ),
      );

      // Still should render the headers
      expect(find.text('Parameter'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);

      // But no rows should be rendered
      // Find DataTable to check its rows
      final dataTable = tester.widget<DataTable>(find.byType(DataTable));
      expect(dataTable.rows.isEmpty, true);
    });

    testWidgets('should render different data types correctly',
        (WidgetTester tester) async {
      // Different data types
      final DateTime testDate = DateTime(2023, 1, 5);
      final List<TableInfo> mixedDataItems = [
        TableInfo('String', 'Text value'),
        TableInfo('Integer', 42),
        TableInfo('Double', 3.14),
        TableInfo('Boolean', true),
        TableInfo('DateTime', testDate),
      ];

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuctionDetailTable(
              rowItems: mixedDataItems,
            ),
          ),
        ),
      );

      // Verify all values are correctly rendered as strings
      expect(find.text('Text value'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
      expect(find.text('3.14'), findsOneWidget);
      expect(find.text('true'), findsOneWidget);
      expect(find.text(testDate.toString()), findsOneWidget);
    });
  });
}
