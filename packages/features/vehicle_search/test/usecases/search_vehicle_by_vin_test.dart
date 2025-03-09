// test/domain/usecases/search_vehicle_by_vin_test.dart

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vehicle_selection/src/vehicle_search.dart';

import 'search_vehicle_by_vin_test.mocks.dart';


@GenerateMocks([VehicleSearchRepository])
void main() {
  late SearchVehicleByVin usecase;
  late MockVehicleSearchRepository mockRepository;

  setUp(() {
    mockRepository = MockVehicleSearchRepository();
    usecase = SearchVehicleByVin(mockRepository);
  });

  const testVin = 'WVWZZZ1KZAW123456';
  final testChoices = [
    const VehicleChoice(
      make: 'Toyota',
      model: 'GT 86',
      containerName: 'Test Container',
      similarity: 80,
      externalId: 'test-id-1',
    ),
  ];

  final testResult = SearchResult(choices: testChoices);

  test('should get search result from the repository', () async {
    // Arrange
    when(mockRepository.searchByVin(testVin))
        .thenAnswer((_) async => Right(testResult));

    // Act
    final result = await usecase(testVin);

    // Assert
    expect(result, Right(testResult));
    verify(mockRepository.searchByVin(testVin));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // Arrange
    final failure = NetworkFailure('Network error');
    when(mockRepository.searchByVin(testVin))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(testVin);

    // Assert
    expect(result, Left(failure));
    verify(mockRepository.searchByVin(testVin));
    verifyNoMoreInteractions(mockRepository);
  });
}
