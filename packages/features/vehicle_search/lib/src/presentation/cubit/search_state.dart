part of 'search_cubit.dart';


class SearchState extends Equatable {
  final SearchStatus status;
  final String errorMessage;
  final Auction? auction;
  final List<VehicleChoice>? choices;
  final String vin;
  final String? selectedExternalId;

  const SearchState({
    this.status = SearchStatus.initial,
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

  SearchState copyWith({
    SearchStatus? status,
    String? errorMessage,
    Auction? auction,
    List<VehicleChoice>? choices,
    String? vin,
    String? selectedExternalId,
  }) {
    return SearchState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      auction: auction ?? this.auction,
      choices: choices ?? this.choices,
      vin: vin ?? this.vin,
      selectedExternalId: selectedExternalId ?? this.selectedExternalId,
    );
  }
}

enum SearchStatus {
  initial,
  loading,
  loaded,
  multipleChoices,
  error,
}
