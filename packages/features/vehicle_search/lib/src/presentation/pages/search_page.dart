// lib/src/presentation/pages/search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_selection/src/presentation/pages/factory/search_state_widget_factory.dart';
import '../cubit/search_cubit.dart';

class SearchPage extends StatelessWidget {
  final Function(String auctionId)? onVehicleSelected;

  const SearchPage({
    super.key,
    this.onVehicleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Search'),
      ),
      body: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {
          if (state.status == SearchStatus.selected &&
              state.auctionId != null &&
              onVehicleSelected != null) {
            onVehicleSelected!(state.auctionId!);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchStateWidgetFactory.build(context, state),
          );
        },
      ),
    );
  }
}
