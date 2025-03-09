import 'package:flutter/material.dart';
import 'package:ui_kit/src/components/lists/choice_list_view.dart';

/// View for displaying multiple options for user selection
class MultipleChoicesView<T> extends StatelessWidget {
  /// Title to display above the choices
  final String title;

  /// Description text
  final String description;

  /// List of items to choose from
  final List<T> choices;

  /// Widget builder for each choice
  final Widget Function(BuildContext context, T item) itemBuilder;

  const MultipleChoicesView({
    super.key,
    required this.title,
    required this.description,
    required this.choices,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ChoiceListView<T>(
            items: choices,
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}
