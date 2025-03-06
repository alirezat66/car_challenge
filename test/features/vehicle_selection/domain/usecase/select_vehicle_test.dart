// test/features/vehicle_selection/domain/usecases/select_vehicle_test.dart
import 'package:car_challenge/features/vehicle_selection/domain/usecases/select_vehicle_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle.dart';

import 'get_vehicle_data_test.mocks.dart';

void main() {
  late SelectVehicle useCase;
  late MockVehicleRepository mockRepository;

  setUp(() {
    mockRepository = MockVehicleRepository();
    useCase = SelectVehicle(mockRepository);
  });

  const vin = '1HGCM82633A004352';
  final vehicles = [
    Vehicle(vin: vin, make: 'Honda', model: 'Accord'),
    Vehicle(vin: '2HGCM82633A004353', make: 'Honda', model: 'Civic'),
  ];
  final selectedVehicle = vehicles[0];
  final params = SelectVehicleParams(vin, vehicles);

  test('should return selected vehicle when selectVehicle succeeds', () async {
    when(mockRepository.selectVehicle(any, any))
        .thenAnswer((_) async => Right(selectedVehicle));

    final result = await useCase(params);

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Should return a success'),
      (vehicle) => expect(vehicle, selectedVehicle),
    );
    verify(mockRepository.selectVehicle(vin, vehicles)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when selectVehicle fails', () async {
    when(mockRepository.selectVehicle(any, any))
        .thenAnswer((_) async => Left(ServerFailure()));

    final result = await useCase(params);

    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Should return a failure'),
    );
    verify(mockRepository.selectVehicle(vin, vehicles)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
