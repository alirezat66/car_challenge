import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/features/user_identification/data/models/user_model.dart';
import 'package:car_challenge/features/vehicle_selection/data/datasources/vehicle_local_data_source.dart';
import 'package:car_challenge/features/vehicle_selection/data/datasources/vehicle_remote_data_source.dart';
import 'package:car_challenge/features/vehicle_selection/data/repositories/vehicle_repository_impl.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_choice.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_data.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../models/vehicle_auction_model_test.dart';
import 'vehicle_repository_impl_test.mocks.dart';

final tVehicleEntity = tVehicleAuctionModel.toEntity();
final tVehicleChoices = [
  VehicleChoice(
    make: "Toyota",
    model: "GT 86 Basis",
    containerName: "DE - Cp2 2.0 EU5, 2012 - 2015",
    similarity: 75,
    externalId: "DE001-018601450020001",
  ),
  VehicleChoice(
    make: "Toyota",
    model: "GT 86 Basis",
    containerName: "DE - Cp2 2.0 EU6, (EURO 6), 2015 - 2017",
    similarity: 50,
    externalId: "DE002-018601450020001",
  ),
];

@GenerateMocks([VehicleRemoteDataSource, VehicleLocalDataSource])
void main() {
  late VehicleRepositoryImpl repository;
  late MockVehicleRemoteDataSource mockRemoteDataSource;
  late MockVehicleLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockVehicleRemoteDataSource();
    mockLocalDataSource = MockVehicleLocalDataSource();
    repository = VehicleRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tUserId = 'test-user-id';
  final tUserModel = UserModel(tUserId);
  const tVin = 'TEST12345678901234';

  test(
      'should return vehicle auction data when remote data source is successful with code 200',
      () async {
    final resultExpect = VehicleData(auction: tVehicleEntity);
    // arrange
    when(mockLocalDataSource.getUser()).thenReturn(tUserModel);
    when(mockRemoteDataSource.getVehicleData(
      userId: tUserId,
      vin: tVin,
    )).thenAnswer((_) async => resultExpect);

    // act
    final result = await repository.getVehicleData(vin: tVin);

    // assert
    verify(mockRemoteDataSource.getVehicleData(
      userId: tUserId,
      vin: tVin,
    ));

    expect(result, equals(Right(resultExpect)));
  });

  test(
      'should save auction data locally when remote data source returns a vehicle auction',
      () async {
    // arrange
    when(mockLocalDataSource.getUser()).thenReturn(tUserModel);
    when(mockRemoteDataSource.getVehicleData(
      userId: tUserId,
      vin: tVin,
    )).thenAnswer((_) async => VehicleData(auction: tVehicleEntity));

    // act
    await repository.getVehicleData(vin: tVin);

    // assert
    verify(mockLocalDataSource.saveVehicleAuction(any));
  });

  test(
      'should return vehicle choices when remote data source is successful with code 300',
      () async {
    final expectedData = VehicleData(choices: tVehicleChoices);
    // arrange
    when(mockLocalDataSource.getUser()).thenReturn(tUserModel);
    when(mockRemoteDataSource.getVehicleData(
      userId: tUserId,
      vin: tVin,
    )).thenAnswer((_) async => expectedData);

    // act
    final result = await repository.getVehicleData(vin: tVin);

    // assert
    verify(mockRemoteDataSource.getVehicleData(
      userId: tUserId,
      vin: tVin,
    ));

    expect(result, equals(Right(expectedData)));
  });

  test(
      'should return cached data when remote data source fails and cache exists',
      () async {
    final expectedData = VehicleData(auction: tVehicleEntity);
    // arrange
    when(mockLocalDataSource.getUser()).thenReturn(tUserModel);
    when(mockRemoteDataSource.getVehicleData(
      userId: tUserId,
      vin: tVin,
    )).thenThrow(ServerFailure());
    when(mockLocalDataSource.getVehicleAuction())
        .thenAnswer((_) async => Right(tVehicleEntity));

    // act
    final result = await repository.getVehicleData(vin: tVin);

    // assert
    verify(mockRemoteDataSource.getVehicleData(
      userId: tUserId,
      vin: tVin,
    ));
    verify(mockLocalDataSource.getVehicleAuction());
    expect(result.isRight(), true);
    result.fold((l) => null,
        (r) => expect(r.auction!.id, equals(expectedData.auction!.id)));
  });

  test(
      'should return remote error when remote data source fails and cache is empty',
      () async {
    // arrange
    final tFailure = ServerFailure();
    when(mockLocalDataSource.getUser()).thenReturn(tUserModel);
    when(mockRemoteDataSource.getVehicleData(
      userId: tUserId,
      vin: tVin,
    )).thenThrow(tFailure);
    when(mockLocalDataSource.getVehicleAuction())
        .thenAnswer((_) async => Left(LocalStorageFailure()));

    // act
    final result = await repository.getVehicleData(vin: tVin);

    // assert
    verify(mockRemoteDataSource.getVehicleData(
      userId: tUserId,
      vin: tVin,
    ));
    verify(mockLocalDataSource.getVehicleAuction());
    expect(result, equals(Left(tFailure)));
  });

  test('should return IdentificationFailure when user is not authenticated',
      () async {
    // arrange
    when(mockLocalDataSource.getUser()).thenReturn(null);

    // act
    final result = await repository.getVehicleData(vin: tVin);

    // assert
    verify(mockLocalDataSource.getUser());
    expect(result.isLeft(), isTrue);

    result.fold((failure) {
      expect(failure, isA<IdentificationFailure>());
    }, (_) => fail('Should return a failure'));
  });
  test('when user exist then we call remote get', () async {
    when(mockLocalDataSource.getUser()).thenReturn(tUserModel);

    when(mockRemoteDataSource.getVehicleData(
            userId: anyNamed('userId'),
            vin: anyNamed('vin'),
            externalId: anyNamed('externalId')))
        .thenAnswer((_) async => VehicleData()); // Return some test data

    // Act
    await repository.getVehicleData(vin: tVin);

    // Assert
    verify(mockRemoteDataSource.getVehicleData(
        userId: anyNamed('userId'),
        vin: anyNamed('vin'),
        externalId: anyNamed('externalId')));
  });
}
