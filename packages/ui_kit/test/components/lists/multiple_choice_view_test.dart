import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/src/components/lists/choice_list_view.dart';
import 'package:ui_kit/src/components/lists/multiple_choice_view.dart';

// Mock model for testing
class TestChoice {
  final String name;
  final int id;

  TestChoice(this.name, this.id);
}

void main() {
  group('MultipleChoicesView', () {
    final List<TestChoice> mockChoices = [
      TestChoice('Option 1', 1),
      TestChoice('Option 2', 2),
      TestChoice('Option 3', 3),
    ];

    Widget buildItemCard(BuildContext context, TestChoice item) {
      return Card(
        child: ListTile(
          title: Text(item.name),
          subtitle: Text('ID: ${item.id}'),
        ),
      );
    }

    testWidgets('should display title and description',
        (WidgetTester tester) async {
      const String title = 'Select an Option';
      const String description = 'Please choose from the available options';

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultipleChoicesView<TestChoice>(
              title: title,
              description: description,
              choices: mockChoices,
              itemBuilder: buildItemCard,
            ),
          ),
        ),
      );

      // Verify that the title and description are displayed
      expect(find.text(title), findsOneWidget);
      expect(find.text(description), findsOneWidget);
    });

    testWidgets('should render all choices using itemBuilder',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultipleChoicesView<TestChoice>(
              title: 'Select an Option',
              description: 'Choose an option',
              choices: mockChoices,
              itemBuilder: buildItemCard,
            ),
          ),
        ),
      );

      // Verify that all choice items are rendered
      for (var choice in mockChoices) {
        expect(find.text(choice.name), findsOneWidget);
        expect(find.text('ID: ${choice.id}'), findsOneWidget);
      }

      // Verify we have the correct number of cards
      expect(find.byType(Card), findsNWidgets(mockChoices.length));
    });

    testWidgets('should handle empty choices list',
        (WidgetTester tester) async {
      // Build the widget with an empty list
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultipleChoicesView<TestChoice>(
              title: 'No Options',
              description: 'No options available',
              choices: const [], // Empty list
              itemBuilder: buildItemCard,
            ),
          ),
        ),
      );

      // Verify that the title and description are still displayed
      expect(find.text('No Options'), findsOneWidget);
      expect(find.text('No options available'), findsOneWidget);

      // Verify that no cards are rendered
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('should use a ChoiceListView internally',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultipleChoicesView<TestChoice>(
              title: 'Select an Option',
              description: 'Choose an option',
              choices: mockChoices,
              itemBuilder: buildItemCard,
            ),
          ),
        ),
      );

      // Verify that it uses ChoiceListView internally
      expect(find.byType(ChoiceListView<TestChoice>), findsOneWidget);
    });
  });
}
