// lib/src/presentation/cubit/search_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/vehicle_choice.dart';
import '../../domain/usecases/search_vehicle_by_vin.dart';
import '../../domain/usecases/select_vehicle_option.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchVehicleByVin searchVehicleByVin;
  final SelectVehicleOption selectVehicleOption;

  SearchCubit({
    required this.searchVehicleByVin,
    required this.selectVehicleOption,
  }) : super(const SearchState());

  Future<void> searchByVin(String vin) async {
    emit(state.copyWith(status: SearchStatus.loading, vin: vin));

    final result = await searchVehicleByVin(vin);

    result.fold(
      (failure) => emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: failure.message,
      )),
      (searchResult) {
        if (searchResult.hasSelectedOption) {
          emit(state.copyWith(
            status: SearchStatus.selected,
            selectedExternalId: searchResult.selectedExternalId,
          ));
        } else if (searchResult.hasMultipleChoices) {
          // Sort choices by similarity (highest first)
          final sortedChoices = List<VehicleChoice>.from(searchResult.choices!)
            ..sort((a, b) => b.similarity.compareTo(a.similarity));

          emit(state.copyWith(
            status: SearchStatus.multipleChoices,
            choices: sortedChoices,
          ));
        } else {
          emit(state.copyWith(
            status: SearchStatus.error,
            errorMessage: 'Invalid search result',
          ));
        }
      },
    );
  }

  Future<void> selectVehicle(String externalId) async {
    emit(state.copyWith(
      status: SearchStatus.loading,
      selectedExternalId: externalId,
    ));

    final result = await selectVehicleOption(externalId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: failure.message,
      )),
      (auctionId) => emit(state.copyWith(
        status: SearchStatus.selected,
        selectedExternalId: externalId,
        auctionId: auctionId,
      )),
    );
  }

  void retry() {
    if (state.vin.isNotEmpty) {
      if (state.selectedExternalId != null) {
        selectVehicle(state.selectedExternalId!);
      } else {
        searchByVin(state.vin);
      }
    } else {
      emit(state.copyWith(status: SearchStatus.initial));
    }
  }
}
