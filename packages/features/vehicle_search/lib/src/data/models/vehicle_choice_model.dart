// lib/src/data/models/vehicle_choice_model.dart
import '../../domain/entities/vehicle_choice.dart';

class VehicleChoiceModel {
  final String make;
  final String model;
  final String containerName;
  final int similarity;
  final String externalId;

  VehicleChoiceModel({
    required this.make,
    required this.model,
    required this.containerName,
    required this.similarity,
    required this.externalId,
  });

  factory VehicleChoiceModel.fromJson(Map<String, dynamic> json) {
    return VehicleChoiceModel(
      make: json['make'] as String,
      model: json['model'] as String,
      containerName: json['containerName'] as String,
      similarity: json['similarity'] as int,
      externalId: json['externalId'] as String,
    );
  }

  VehicleChoice toEntity() {
    return VehicleChoice(
      make: make,
      model: model,
      containerName: containerName,
      similarity: similarity,
      externalId: externalId,
    );
  }
}
