import 'package:flutter/material.dart';
import 'package:ui_kit/src/components/table/auction_detail_row.dart';
import 'package:ui_kit/src/theme/theme_extension.dart';

class TableInfo {
  final String name;
  final dynamic value;

  TableInfo(this.name, this.value);
}

/// Table component for displaying detailed auction information
class AuctionDetailTable extends StatelessWidget {
  /// List of table information items
  final List<TableInfo> rowItems;

  const AuctionDetailTable({
    super.key,
    required this.rowItems,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Allows horizontal scrolling if needed
      child: DataTable(
        border: TableBorder.all(
          color: context.primaryColor, // Border color
          width: 1.5,
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
        columnSpacing: 40.0, // Spacing between columns
        headingRowHeight: 50.0,

        columns: <DataColumn>[
          DataColumn(
            label: Text(
              'Parameter',
              style: context.titleLarge,
            ),
          ),
          DataColumn(
            label: Text(
              'Value',
              style: context.titleLarge,
            ),
          ),
        ],
        rows: rowItems.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;
          final color = index.isEven ? context.primaryColor : Colors.white;
          return AuctionDetailRow(
              paramTitle: item.name, // Example usage of index
              paramValue: item.value.toString(),
              color: color.withOpacity(0.1));
        }).toList(),
      ),
    );
  }
}
