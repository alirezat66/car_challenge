// test/features/vehicle_selection/domain/usecases/fetch_vehicle_data_test.dart
import 'package:car_challenge/features/vehicle_selection/domain/usecases/get_vehicle_data.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle.dart';
import 'package:car_challenge/features/vehicle_selection/domain/repositories/vehicle_repository.dart';

import 'get_vehicle_data_test.mocks.dart';

@GenerateMocks([VehicleRepository])
void main() {
  late GetVehicleData useCase;
  late MockVehicleRepository mockRepository;

  setUp(() {
    mockRepository = MockVehicleRepository();
    useCase = GetVehicleData(mockRepository);
  });

  const vin = '1HGCM82633A004352';
  final vehicles = [
    Vehicle(vin: vin, make: 'Honda', model: 'Accord'),
  ];

  test('should return list of vehicles when fetchVehiclesByVin succeeds',
      () async {
    when(mockRepository.fetchVehiclesByVin(any))
        .thenAnswer((_) async => Right(vehicles));

    final result = await useCase(vin);

    expect(result, Right(vehicles));
    verify(mockRepository.fetchVehiclesByVin(vin)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when fetchVehiclesByVin fails', () async {
    when(mockRepository.fetchVehiclesByVin(any))
        .thenAnswer((_) async => Left(NetworkFailure()));

    final result = await useCase(vin);

    expect(result.isLeft(), true);
    result.fold((failure) {
      expect(failure, isA<NetworkFailure>());
    }, (_) => fail('Should return a failure'));
    verify(mockRepository.fetchVehiclesByVin(vin)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
