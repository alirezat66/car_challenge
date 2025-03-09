// test/data/models/vehicle_choice_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_selection/src/data/models/vehicle_choice_model.dart';
import 'package:vehicle_selection/src/domain/entities/vehicle_choice.dart';

void main() {
  const testMake = 'Toyota';
  const testModel = 'GT 86';
  const testContainerName = 'DE - Cp2 2.0 EU5, 2012 - 2015';
  const testSimilarity = 80;
  const testExternalId = 'DE001-018601450020001';

  final testJson = {
    'make': testMake,
    'model': testModel,
    'containerName': testContainerName,
    'similarity': testSimilarity,
    'externalId': testExternalId,
  };

  final testVehicleChoiceModel = VehicleChoiceModel(
    make: testMake,
    model: testModel,
    containerName: testContainerName,
    similarity: testSimilarity,
    externalId: testExternalId,
  );

  group('VehicleChoiceModel', () {
    test('should convert from JSON correctly', () {
      // Act
      final result = VehicleChoiceModel.fromJson(testJson);

      // Assert
      expect(result.make, equals(testMake));
      expect(result.model, equals(testModel));
      expect(result.containerName, equals(testContainerName));
      expect(result.similarity, equals(testSimilarity));
      expect(result.externalId, equals(testExternalId));
    });

    test('should convert to entity correctly', () {
      // Act
      final entity = testVehicleChoiceModel.toEntity();

      // Assert
      expect(entity, isA<VehicleChoice>());
      expect(entity.make, equals(testMake));
      expect(entity.model, equals(testModel));
      expect(entity.containerName, equals(testContainerName));
      expect(entity.similarity, equals(testSimilarity));
      expect(entity.externalId, equals(testExternalId));
    });
  });
}
