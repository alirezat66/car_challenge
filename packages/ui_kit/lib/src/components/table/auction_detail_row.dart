import 'package:flutter/material.dart';

/// Row component for auction detail tables
class AuctionDetailRow extends DataRow {
  /// Parameter title/name
  final String paramTitle;

  /// Parameter value as string
  final String paramValue;

  AuctionDetailRow({
    Key? key,
    required this.paramTitle,
    required this.paramValue,
    Color? color,
  }) : super(
          color: WidgetStateProperty.all(
              color ?? Colors.tealAccent.withOpacity(0.1)),
          cells: <DataCell>[
            DataCell(Text(paramTitle)),
            DataCell(Text(paramValue)),
          ],
        );
}
