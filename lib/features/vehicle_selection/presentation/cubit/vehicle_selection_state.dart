part of 'vehicle_selection_cubit.dart';

class VehicleSelectionState extends Equatable {
  final VehicleSelectionStatus status;
  final String errorMessage;
  final VehicleAuction? auction;
  final List<VehicleChoice>? choices;
  final String vin;
  final String? selectedExternalId;

  const VehicleSelectionState({
    this.status = VehicleSelectionStatus.initial,
    this.errorMessage = '',
    this.auction,
    this.choices,
    this.vin = '',
    this.selectedExternalId,
  });

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        auction,
        choices,
        vin,
        selectedExternalId,
      ];

  VehicleSelectionState copyWith({
    VehicleSelectionStatus? status,
    String? errorMessage,
    VehicleAuction? auction,
    List<VehicleChoice>? choices,
    String? vin,
    String? selectedExternalId,
  }) {
    return VehicleSelectionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      auction: auction ?? this.auction,
      choices: choices ?? this.choices,
      vin: vin ?? this.vin,
      selectedExternalId: selectedExternalId ?? this.selectedExternalId,
    );
  }
}

enum VehicleSelectionStatus {
  initial,
  loading,
  loaded,
  multipleChoices,
  error,
}
