import 'package:flutter/material.dart';

class AuctionDetailRow extends DataRow {
  final String paramTitle;
  final String paramValue;

  AuctionDetailRow(
      {Key? key,
      required this.paramTitle,
      required this.paramValue,
      Color? color})
      : super(
          color: WidgetStatePropertyAll(
              color ?? Colors.tealAccent.withOpacity(0.1)),
          cells: <DataCell>[
            DataCell(Text(paramTitle)),
            DataCell(Text(paramValue)),
          ],
        );
}
