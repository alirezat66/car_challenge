// test/presentation/cubit/search_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:vehicle_selection/src/domain/entities/auction.dart';
import 'package:vehicle_selection/src/domain/entities/search_result.dart';
import 'package:vehicle_selection/src/domain/entities/vehicle_choice.dart';
import 'package:vehicle_selection/src/domain/usecases/search_vehicle_by_vin.dart';
import 'package:vehicle_selection/src/domain/usecases/select_vehicle_option.dart';
import 'package:vehicle_selection/src/presentation/cubit/search_cubit.dart';
import 'search_cubit_test.mocks.dart';

@GenerateMocks([SearchVehicleByVin, SelectVehicleOption])
void main() {
  late SearchCubit cubit;
  late MockSearchVehicleByVin mockSearchVehicleByVin;
  late MockSelectVehicleOption mockSelectVehicleOption;

  setUp(() {
    mockSearchVehicleByVin = MockSearchVehicleByVin();
    mockSelectVehicleOption = MockSelectVehicleOption();
    cubit = SearchCubit(
      searchVehicleByVin: mockSearchVehicleByVin,
      selectVehicleOption: mockSelectVehicleOption,
    );
  });

  const testVin = 'TEST12345678901234';
  const testExternalId = 'DE001-018601450020001';

  // Sample auction data for testing
  final testAuction = Auction(
    id: 12345,
    feedback: 'Good condition',
    valuatedAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
    requestedAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
    createdAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
    updatedAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
    make: 'Toyota',
    model: 'GT 86',
    externalId: testExternalId,
    fkSellerUser: 'seller123',
    price: 10000,
    positiveCustomerFeedback: true,
    fkUuidAuction: 'auction-123',
    inspectorRequestedAt: DateTime.parse('2021-01-01T00:00:00.000Z'),
    origin: 'test',
    estimationRequestId: 'est123',
  );

  final testChoices = [
    const VehicleChoice(
      make: 'Toyota',
      model: 'GT 86',
      containerName: 'Test Container',
      similarity: 80,
      externalId: testExternalId,
    ),
    const VehicleChoice(
      make: 'Toyota',
      model: 'GT 86',
      containerName: 'Another Container',
      similarity: 60,
      externalId: 'test-id-2',
    ),
  ];

  group('submitVin', () {
    blocTest<SearchCubit, SearchState>(
      'emits [loading, multipleChoices] when search returns choices',
      build: () {
        when(mockSearchVehicleByVin(any)).thenAnswer(
          (_) async => Right(SearchResult(choices: testChoices)),
        );
        return cubit;
      },
      act: (cubit) => cubit.submitVin(testVin),
      expect: () => [
        isA<SearchState>()
            .having((s) => s.status, 'status', SearchStatus.loading)
            .having((s) => s.errorMessage, 'errorMessage', ''),
        isA<SearchState>()
            .having((s) => s.status, 'status', SearchStatus.multipleChoices)
            .having((s) => s.choices, 'choices', isA<List<VehicleChoice>>())
            .having((s) => s.choices!.length, 'choices length', 2)
            .having((s) => s.choices!.first.similarity,
                'first choice similarity', 80)
      ],
      verify: (_) {
        verify(mockSearchVehicleByVin(testVin)).called(1);
      },
    );

    blocTest<SearchCubit, SearchState>(
      'emits [loading, loaded] when search returns an auction',
      build: () {
        when(mockSearchVehicleByVin(any)).thenAnswer(
          (_) async => Right(SearchResult(auction: testAuction)),
        );
        return cubit;
      },
      act: (cubit) => cubit.submitVin(testVin),
      expect: () => [
        isA<SearchState>()
            .having((s) => s.status, 'status', SearchStatus.loading)
            .having((s) => s.errorMessage, 'errorMessage', ''),
        isA<SearchState>()
            .having((s) => s.status, 'status', SearchStatus.loaded)
            .having((s) => s.auction, 'auction', isNotNull)
            .having((s) => s.auction!.externalId, 'auction externalId',
                testExternalId),
      ],
    );

    blocTest<SearchCubit, SearchState>(
      'emits [loading, error] when search fails',
      build: () {
        when(mockSearchVehicleByVin(any)).thenAnswer(
          (_) async => Left(NetworkFailure('Network error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.submitVin(testVin),
      expect: () => [
        isA<SearchState>()
            .having((s) => s.status, 'status', SearchStatus.loading)
            .having((s) => s.errorMessage, 'errorMessage', ''),
        isA<SearchState>()
            .having((s) => s.status, 'status', SearchStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', 'Network error'),
      ],
    );
  });

  group('selectVehicle', () {
    blocTest<SearchCubit, SearchState>(
      'emits [loading, loaded] when selection succeeds',
      build: () {
        when(mockSelectVehicleOption(any)).thenAnswer(
          (_) async => Right(SearchResult(auction: testAuction)),
        );
        return cubit;
      },
      act: (cubit) => cubit.selectVehicle(testExternalId),
      expect: () => [
        isA<SearchState>()
            .having((s) => s.status, 'status', SearchStatus.loading)
            .having((s) => s.selectedExternalId, 'selectedExternalId',
                testExternalId),
        isA<SearchState>()
            .having((s) => s.status, 'status', SearchStatus.loaded)
            .having((s) => s.selectedExternalId, 'selectedExternalId',
                testExternalId)
            .having((s) => s.auction, 'auction', isNotNull)
            .having((s) => s.auction!.externalId, 'auction externalId',
                testExternalId),
      ],
      verify: (_) {
        verify(mockSelectVehicleOption(testExternalId)).called(1);
      },
    );

    blocTest<SearchCubit, SearchState>(
      'emits [loading, error] when selection fails',
      build: () {
        when(mockSelectVehicleOption(any)).thenAnswer(
          (_) async => Left(ServerFailure('Server error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.selectVehicle(testExternalId),
      expect: () => [
        isA<SearchState>()
            .having((s) => s.status, 'status', SearchStatus.loading)
            .having((s) => s.selectedExternalId, 'selectedExternalId',
                testExternalId),
        isA<SearchState>()
            .having((s) => s.status, 'status', SearchStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', 'Server error'),
      ],
    );

    blocTest<SearchCubit, SearchState>(
      'emits [loading, error] when selection returns unexpected structure',
      build: () {
        when(mockSelectVehicleOption(any)).thenAnswer(
          (_) async => Right(SearchResult(
              choices: testChoices)), // Unexpected result structure
        );
        return cubit;
      },
      act: (cubit) => cubit.selectVehicle(testExternalId),
      expect: () => [
        isA<SearchState>()
            .having((s) => s.status, 'status', SearchStatus.loading)
            .having((s) => s.selectedExternalId, 'selectedExternalId',
                testExternalId),
        isA<SearchState>()
            .having((s) => s.status, 'status', SearchStatus.error)
            .having((s) => s.errorMessage, 'errorMessage',
                'Unexpected response after vehicle selection'),
      ],
    );
  });

  group('retry', () {
    

    test('calls selectVehicle when there is a selectedExternalId', () {
      // Arrange
      when(mockSelectVehicleOption(any)).thenAnswer(
        (_) async => Right(SearchResult(auction: testAuction)),
      );
      cubit.emit(const SearchState(
        status: SearchStatus.error,
        errorMessage: 'Previous error',
        vin: testVin,
        selectedExternalId: testExternalId,
      ));

      // Act
      cubit.retry();

      // Assert
      verify(mockSelectVehicleOption(testExternalId)).called(1);
    });
  });
}
