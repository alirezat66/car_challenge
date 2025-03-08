import 'package:car_challenge/features/vehicle_selection/data/models/vehicle_choice_model.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_choice.dart';
import 'package:flutter_test/flutter_test.dart';

final tVehicleChoiceModel = VehicleChoiceModel(
  make: "Toyota",
  model: "GT 86 Basis",
  containerName: "DE - Cp2 2.0 EU5, 2012 - 2015",
  similarity: 75,
  externalId: "DE001-018601450020001",
);

final Map<String, dynamic> vehicleJsonMap = {
  "make": "Toyota",
  "model": "GT 86 Basis",
  "containerName": "DE - Cp2 2.0 EU5, 2012 - 2015",
  "similarity": 75,
  "externalId": "DE001-018601450020001",
};
void main() {
  group('VehicleChoiceModel', () {
    test('should be a subclass of VehicleChoice entity', () {
      // assert
      expect(tVehicleChoiceModel.toEntity(), isA<VehicleChoice>());
    });

    test('should correctly parse from JSON', () {
      // act
      final result = VehicleChoiceModel.fromJson(vehicleJsonMap);

      // assert
      expect(result.make, equals(tVehicleChoiceModel.make));
      expect(result.model, equals(tVehicleChoiceModel.model));
      expect(result.containerName, equals(tVehicleChoiceModel.containerName));
      expect(result.similarity, equals(tVehicleChoiceModel.similarity));
      expect(result.externalId, equals(tVehicleChoiceModel.externalId));
    });
  });
}
