import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_selection/src/domain/entities/auction.dart';
import 'package:vehicle_selection/vehicle_search.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchVehicleByVin searchVehicleByVin;
  final SelectVehicleOption selectVehicleOption;
  SearchCubit(
      {required this.searchVehicleByVin, required this.selectVehicleOption})
      : super(const SearchState());

  Future<void> submitVin(String vin) async {
    emit(state.copyWith(
      status: SearchStatus.loading,
      errorMessage: '',
    ));

    final result = await searchVehicleByVin.call(vin);

    result.fold(
      (Failure failure) => emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: failure.message,
      )),
      (vehicleData) {
        if (vehicleData.auction != null) {
          emit(state.copyWith(
            status: SearchStatus.loaded,
            auction: vehicleData.auction,
          ));
        } else if (vehicleData.choices != null) {
          // Sort by similarity (highest first)
          final sortedChoices = List<VehicleChoice>.from(vehicleData.choices!)
            ..sort((a, b) => b.similarity.compareTo(a.similarity));

          emit(state.copyWith(
            status: SearchStatus.multipleChoices,
            choices: sortedChoices,
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

    final result = await selectVehicleOption.call(
      externalId,
    );

    result.fold(
      (Failure failure) => emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: failure.message,
      )),
      (vehicleData) {
        if (vehicleData.auction != null) {
          emit(state.copyWith(
            status: SearchStatus.loaded,
            auction: vehicleData.auction,
          ));
        } else {
          emit(state.copyWith(
            status: SearchStatus.error,
            errorMessage: 'Unexpected response after vehicle selection',
          ));
        }
      },
    );
  }

  Future retry() async {
    if (state.vin.isNotEmpty && state.selectedExternalId == null) {
      emit(state.copyWith(status: SearchStatus.initial));
    } else if (state.selectedExternalId != null) {
      await selectVehicle(state.selectedExternalId!);
    } else {
      submitVin(state.vin);
    }
  }
}
