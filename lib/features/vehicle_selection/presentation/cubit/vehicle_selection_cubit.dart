import 'package:bloc/bloc.dart';
import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_auction.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_choice.dart';
import 'package:car_challenge/features/vehicle_selection/domain/usecases/get_vehicle_data.dart';
import 'package:equatable/equatable.dart';

part 'vehicle_selection_state.dart';
class VehicleSelectionCubit extends Cubit<VehicleSelectionState> {
  final GetVehicleData getVehicleData;

  VehicleSelectionCubit({required this.getVehicleData})
      : super(const VehicleSelectionState());


  Future<void> submitVin(String vin) async {
    emit(state.copyWith(
      status: VehicleSelectionStatus.loading,
      errorMessage: '',
    ));

    final result = await getVehicleData.call(GetVehicleDataParams(vin: vin));

    result.fold(
      (Failure failure) => emit(state.copyWith(
        status: VehicleSelectionStatus.error,
        errorMessage: failure.message,
      )),
      (vehicleData) {
        if (vehicleData.auction != null) {
          emit(state.copyWith(
            status: VehicleSelectionStatus.loaded,
            auction: vehicleData.auction,
          ));
        } else if (vehicleData.choices != null) {
          // Sort by similarity (highest first)
          final sortedChoices = List<VehicleChoice>.from(vehicleData.choices!)
            ..sort((a, b) => b.similarity.compareTo(a.similarity));

          emit(state.copyWith(
            status: VehicleSelectionStatus.multipleChoices,
            choices: sortedChoices,
          ));
        }
      },
    );
  }

  Future<void> selectVehicle(String externalId) async {
    emit(state.copyWith(
      status: VehicleSelectionStatus.loading,
      selectedExternalId: externalId,
    ));

    final result = await getVehicleData.call(
      GetVehicleDataParams(externalId: externalId),
    );

    result.fold(
      (Failure failure) => emit(state.copyWith(
        status: VehicleSelectionStatus.error,
        errorMessage: failure.message,
      )),
      (vehicleData) {
        if (vehicleData.auction != null) {
          emit(state.copyWith(
            status: VehicleSelectionStatus.loaded,
            auction: vehicleData.auction,
          ));
        } else {
          emit(state.copyWith(
            status: VehicleSelectionStatus.error,
            errorMessage: 'Unexpected response after vehicle selection',
          ));
        }
      },
    );
  }
}
