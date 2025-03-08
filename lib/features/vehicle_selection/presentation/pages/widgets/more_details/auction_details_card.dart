import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_auction.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/pages/widgets/more_details/auction_detail_table.dart';
import 'package:flutter/material.dart';

class AuctionDetailsCard extends StatelessWidget {
  final VehicleAuction auction;

  const AuctionDetailsCard({super.key, required this.auction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Additional Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          AuctionDetailTable(
            rowItems: [
              TableInfo('ID', auction.id),
              TableInfo('Origin', auction.origin),
              TableInfo('Seller User', auction.fkSellerUser),
              TableInfo('Valuation Date', auction.valuatedAt),
              TableInfo('Created Date', auction.createdAt),
              TableInfo('Updated Date', auction.updatedAt),
              TableInfo('Estimation Request ID', auction.estimationRequestId),
            ],
          )
        ]),
      ),
    );
  }
}
