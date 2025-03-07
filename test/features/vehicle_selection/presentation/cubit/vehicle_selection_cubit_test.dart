import 'package:bloc_test/bloc_test.dart';
import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_choice.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_data.dart';
import 'package:car_challenge/features/vehicle_selection/domain/usecases/get_vehicle_data.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/cubit/vehicle_selection_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../data/models/vehicle_auction_model_test.dart';
import 'vehicle_selection_cubit_test.mocks.dart';

@GenerateMocks([GetVehicleData])
final testAuction = tVehicleAuctionModel.toEntity();
final testChoices = [
  VehicleChoice(
      make: 'Toyota',
      model: 'GT 86 Basis',
      containerName: 'DE - Cp2 2.0 EU5, 2012 - 2015',
      similarity: 80,
      externalId: 'DE001-018601450020001'),
  VehicleChoice(
      make: 'Toyota',
      model: 'GT 86 Basis',
      containerName: 'DE - Cp2 2.0 EU6, (EURO 6), 2015 - 2017',
      similarity: 50,
      externalId: 'DE002-018601450020001'),
];

void main() {
  late MockGetVehicleData mockGetVehicleData;
  late VehicleSelectionCubit cubit;

  setUp(() {
    mockGetVehicleData = MockGetVehicleData();
    cubit = VehicleSelectionCubit(getVehicleData: mockGetVehicleData);
  });

  tearDown(() {
    cubit.close();
  });

  group('VehicleSelectionCubit', () {
    const testVin = 'WVWZZZ1KZAW123456';
    const testExternalId = 'DE001-018601450020001';

    test('initial state should be VehicleSelectionState with status initial',
        () {
      // Assert
      expect(cubit.state, const VehicleSelectionState());
      expect(cubit.state.status, VehicleSelectionStatus.initial);
    });

    group('submitVin', () {
      void setupSuccessWithAuction() {
        when(mockGetVehicleData(any))
            .thenAnswer((_) async => Right(VehicleData(auction: testAuction)));
      }

      void setupSuccessWithMultipleChoices() {
        when(mockGetVehicleData(any))
            .thenAnswer((_) async => Right(VehicleData(choices: testChoices)));
      }

      void setupFailure() {
        when(mockGetVehicleData(any))
            .thenAnswer((_) async => Left(ServerFailure('Error occurred')));
      }

      blocTest<VehicleSelectionCubit, VehicleSelectionState>(
        'emits [loading, loaded] when submitVin succeeds with auction data',
        build: () {
          setupSuccessWithAuction();
          return cubit;
        },
        act: (cubit) => cubit.submitVin(testVin),
        expect: () => [
          isA<VehicleSelectionState>().having(
              (s) => s.status, 'status', VehicleSelectionStatus.loading),
          isA<VehicleSelectionState>()
              .having((s) => s.status, 'status', VehicleSelectionStatus.loaded)
              .having((s) => s.auction, 'auction', testAuction),
        ],
        verify: (_) {
          verify(mockGetVehicleData(any)).called(1);
        },
      );

      blocTest<VehicleSelectionCubit, VehicleSelectionState>(
        'emits [loading, multipleChoices] when submitVin succeeds with multiple choices',
        build: () {
          setupSuccessWithMultipleChoices();
          return cubit;
        },
        act: (cubit) => cubit.submitVin(testVin),
        expect: () => [
          isA<VehicleSelectionState>().having(
              (s) => s.status, 'status', VehicleSelectionStatus.loading),
          isA<VehicleSelectionState>()
              .having((s) => s.status, 'status',
                  VehicleSelectionStatus.multipleChoices)
              .having((s) => s.choices, 'choices', isA<List<VehicleChoice>>()),
        ],
        verify: (_) {
          verify(mockGetVehicleData(any)).called(1);
        },
      );

      blocTest<VehicleSelectionCubit, VehicleSelectionState>(
        'emits [loading, error] when submitVin fails',
        build: () {
          setupFailure();
          return cubit;
        },
        act: (cubit) => cubit.submitVin(testVin),
        expect: () => [
          isA<VehicleSelectionState>().having(
              (s) => s.status, 'status', VehicleSelectionStatus.loading),
          isA<VehicleSelectionState>()
              .having((s) => s.status, 'status', VehicleSelectionStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', 'Error occurred'),
        ],
        verify: (_) {
          verify(mockGetVehicleData(any)).called(1);
        },
      );
    });

    group('selectVehicle', () {
      void setupSuccessWithAuction() {
        when(mockGetVehicleData(any))
            .thenAnswer((_) async => Right(VehicleData(auction: testAuction)));
      }

      void setupFailure() {
        when(mockGetVehicleData(any))
            .thenAnswer((_) async => Left(ServerFailure('Error occurred')));
      }

      void setupSuccessWithEmptyData() {
        when(mockGetVehicleData(any))
            .thenAnswer((_) async => const Right(VehicleData()));
      }

      blocTest<VehicleSelectionCubit, VehicleSelectionState>(
        'emits [loading, loaded] when selectVehicle succeeds with auction data',
        build: () {
          setupSuccessWithAuction();
          return cubit;
        },
        act: (cubit) => cubit.selectVehicle(testExternalId),
        expect: () => [
          isA<VehicleSelectionState>()
              .having((s) => s.status, 'status', VehicleSelectionStatus.loading)
              .having((s) => s.selectedExternalId, 'selectedExternalId',
                  testExternalId),
          isA<VehicleSelectionState>()
              .having((s) => s.status, 'status', VehicleSelectionStatus.loaded)
              .having((s) => s.auction, 'auction', testAuction)
              .having((s) => s.selectedExternalId, 'selectedExternalId',
                  testExternalId),
        ],
        verify: (_) {
          verify(mockGetVehicleData(any)).called(1);
        },
      );

      blocTest<VehicleSelectionCubit, VehicleSelectionState>(
        'emits [loading, error] when selectVehicle fails',
        build: () {
          setupFailure();
          return cubit;
        },
        act: (cubit) => cubit.selectVehicle(testExternalId),
        expect: () => [
          isA<VehicleSelectionState>()
              .having((s) => s.status, 'status', VehicleSelectionStatus.loading)
              .having((s) => s.selectedExternalId, 'selectedExternalId',
                  testExternalId),
          isA<VehicleSelectionState>()
              .having((s) => s.status, 'status', VehicleSelectionStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', 'Error occurred')
              .having((s) => s.selectedExternalId, 'selectedExternalId',
                  testExternalId),
        ],
        verify: (_) {
          verify(mockGetVehicleData(any)).called(1);
        },
      );

      blocTest<VehicleSelectionCubit, VehicleSelectionState>(
        'emits [loading, error] when selectVehicle returns empty data',
        build: () {
          setupSuccessWithEmptyData();
          return cubit;
        },
        act: (cubit) => cubit.selectVehicle(testExternalId),
        expect: () => [
          isA<VehicleSelectionState>()
              .having((s) => s.status, 'status', VehicleSelectionStatus.loading)
              .having((s) => s.selectedExternalId, 'selectedExternalId',
                  testExternalId),
          isA<VehicleSelectionState>()
              .having((s) => s.status, 'status', VehicleSelectionStatus.error)
              .having((s) => s.errorMessage, 'errorMessage',
                  'Unexpected response after vehicle selection')
              .having((s) => s.selectedExternalId, 'selectedExternalId',
                  testExternalId),
        ],
        verify: (_) {
          verify(mockGetVehicleData(any)).called(1);
        },
      );
    });
  });
}
