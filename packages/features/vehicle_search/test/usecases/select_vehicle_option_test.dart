// test/domain/usecases/select_vehicle_option_test.dart
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vehicle_selection/src/vehicle_search.dart';

// Reusing the mock from the other test
import 'search_vehicle_by_vin_test.mocks.dart';

void main() {
  late SelectVehicleOption usecase;
  late MockVehicleSearchRepository mockRepository;

  setUp(() {
    mockRepository = MockVehicleSearchRepository();
    usecase = SelectVehicleOption(mockRepository);
  });

  const testExternalId = 'DE001-018601450020001';
  const testAuctionId = 'auction-123';

  test('should call repository to select vehicle option', () async {
    // Arrange
    when(mockRepository.selectVehicleOption(testExternalId))
        .thenAnswer((_) async => const Right(testAuctionId));

    // Act
    final result = await usecase(testExternalId);

    // Assert
    expect(result, const Right(testAuctionId));
    verify(mockRepository.selectVehicleOption(testExternalId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // Arrange
    final failure = ServerFailure('Server error');
    when(mockRepository.selectVehicleOption(testExternalId))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(testExternalId);

    // Assert
    expect(result, Left(failure));
    verify(mockRepository.selectVehicleOption(testExternalId));
    verifyNoMoreInteractions(mockRepository);
  });
}
