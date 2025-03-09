// part of 'search_cubit.dart'
part of 'search_cubit.dart';

enum SearchStatus {
  initial,
  loading,
  multipleChoices,
  selected,
  error,
}

class SearchState extends Equatable {
  final SearchStatus status;
  final String vin;
  final List<VehicleChoice>? choices;
  final String? selectedExternalId;
  final String? auctionId;
  final String errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.vin = '',
    this.choices,
    this.selectedExternalId,
    this.auctionId,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [
        status,
        vin,
        choices,
        selectedExternalId,
        auctionId,
        errorMessage,
      ];

  SearchState copyWith({
    SearchStatus? status,
    String? vin,
    List<VehicleChoice>? choices,
    String? selectedExternalId,
    String? auctionId,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      vin: vin ?? this.vin,
      choices: choices ?? this.choices,
      selectedExternalId: selectedExternalId ?? this.selectedExternalId,
      auctionId: auctionId ?? this.auctionId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
