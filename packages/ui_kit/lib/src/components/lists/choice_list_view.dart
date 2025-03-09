import 'package:flutter/material.dart';

/// List view for displaying selectable choices
class ChoiceListView<T> extends StatelessWidget {
  /// List of items to display
  final List<T> items;

  /// Builder function to create item widgets
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Space between items
  final double spacing;

  const ChoiceListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index]);
      },
      separatorBuilder: (_, __) {
        return SizedBox(height: spacing);
      },
      itemCount: items.length,
    );
  }
}
