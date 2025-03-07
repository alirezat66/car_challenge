import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_data.dart';
import 'package:car_challenge/features/vehicle_selection/domain/repositories/vehicle_repository.dart';
import 'package:car_challenge/features/vehicle_selection/domain/usecases/get_vehicle_data.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../data/repository/vehicle_repository_impl_test.dart';
import 'get_vehicle_data_test.mocks.dart';

@GenerateMocks([VehicleRepository])
void main() {
  late GetVehicleData usecase;
  late MockVehicleRepository mockRepository;

  setUp(() {
    mockRepository = MockVehicleRepository();
    usecase = GetVehicleData(mockRepository);
  });

  const tVin = 'WVWZZZ1KZ5W123456';
  const tExternalId = 'DE003-018601450020001';

  final tVehicleData = VehicleData(auction: tVehicleEntity);

  test(
    'should get vehicle data from the repository with VIN',
    () async {
      // arrange
      when(mockRepository.getVehicleData(vin: tVin, externalId: null))
          .thenAnswer((_) async => Right(tVehicleData));

      // act
      final result = await usecase(GetVehicleDataParams(vin: tVin));

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return vehicle data'),
        (data) {
          expect(data.auction, isNotNull);
          expect(data.auction!.id, equals(tVehicleEntity.id));
          expect(data.auction!.make, equals('Toyota'));
        },
      );
      verify(mockRepository.getVehicleData(vin: tVin, externalId: null));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should get vehicle data from the repository with externalId',
    () async {
      // arrange
      when(mockRepository.getVehicleData(vin: null, externalId: tExternalId))
          .thenAnswer((_) async => Right(tVehicleData));

      // act
      final result =
          await usecase(GetVehicleDataParams(externalId: tExternalId));

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return vehicle data'),
        (data) {
          expect(data.auction, isNotNull);
          expect(data.auction!.externalId, equals(tVehicleEntity.externalId));
        },
      );
      verify(mockRepository.getVehicleData(vin: null, externalId: tExternalId));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return failure when repository returns failure',
    () async {
      // arrange
      final tFailure = NetworkFailure('Network error');
      when(mockRepository.getVehicleData(vin: tVin, externalId: null))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(GetVehicleDataParams(vin: tVin));

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, equals('Network error'));
        },
        (_) => fail('Should return a failure'),
      );
      verify(mockRepository.getVehicleData(vin: tVin, externalId: null));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
