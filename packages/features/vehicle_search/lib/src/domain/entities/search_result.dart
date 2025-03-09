// lib/src/domain/entities/search_result.dart
import 'package:equatable/equatable.dart';
import 'vehicle_choice.dart';

class SearchResult extends Equatable {
  final List<VehicleChoice>? choices;
  final String? selectedExternalId;

  const SearchResult({
    this.choices,
    this.selectedExternalId,
  });

  bool get hasMultipleChoices => choices != null && choices!.isNotEmpty;
  bool get hasSelectedOption => selectedExternalId != null;

  @override
  List<Object?> get props => [choices, selectedExternalId];
}
