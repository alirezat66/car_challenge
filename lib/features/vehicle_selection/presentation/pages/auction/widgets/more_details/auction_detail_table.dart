// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:car_challenge/features/vehicle_selection/presentation/pages/auction/widgets/more_details/auction_detail_row.dart';
import 'package:flutter/material.dart';

import 'package:car_challenge/core/theme/theme_extension.dart';

class AuctionDetailTable extends StatelessWidget {
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

class TableInfo {
  final String name;
  dynamic value;

  TableInfo(this.name, this.value);
}
