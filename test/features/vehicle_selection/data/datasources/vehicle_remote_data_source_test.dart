import 'dart:convert';

import 'package:car_challenge/core/client/snippet.dart';
import 'package:car_challenge/core/error/failure.dart';
import 'package:car_challenge/features/vehicle_selection/data/datasources/vehicle_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../models/vehicle_auction_model_test.dart';
import 'vehicle_remote_data_source_test.mocks.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([BaseClient])
void main() {
  late VehicleRemoteDataSourceImpl dataSource;
  late MockBaseClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockBaseClient();
    dataSource = VehicleRemoteDataSourceImpl(mockHttpClient);
  });

  const userId = 'test-user-id';
  const vin = 'TEST12345678901234';
  final testHeaders = {CosChallenge.user: userId, 'vin': vin};

  group('getVehicleData', () {
    void setUpMockHttpClientSuccess200() {
      when(mockHttpClient.get(any, headers: testHeaders)).thenAnswer(
          (_) async => http.Response(json.encode(auctionJson), 200));
    }

    void setUpMockHttpClientSuccess300() {
      final responseJson = [
        {
          "make": "Toyota",
          "model": "GT 86 Basis",
          "containerName": "DE - Cp2 2.0 EU5, 2012 - 2015",
          "similarity": 75,
          "externalId": "DE001-018601450020001"
        },
        {
          "make": "Toyota",
          "model": "GT 86 Basis",
          "containerName": "DE - Cp2 2.0 EU6, (EURO 6), 2015 - 2017",
          "similarity": 50,
          "externalId": "DE002-018601450020001"
        }
      ];

      when(mockHttpClient.get(any, headers: testHeaders)).thenAnswer(
          (_) async => http.Response(json.encode(responseJson), 300));
    }

    void setUpMockHttpClientError() {
      final responseJson = {
        "msgKey": "maintenance",
        "params": {"delaySeconds": "5"},
        "message": "Please try again in 5 seconds"
      };

      when(mockHttpClient.get(any, headers: testHeaders)).thenAnswer(
          (_) async => http.Response(json.encode(responseJson), 400));
    }

    test('should perform a GET request with user and vin in headers', () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      await dataSource.getVehicleData(userId: userId, vin: vin);

      // assert
      verify(mockHttpClient.get(
        any,
        headers: testHeaders,
      ));
    });

    test('should return VehicleData with auction when response code is 200',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      final result =
          await dataSource.getVehicleData(userId: userId, vin: vin);

      // assert
      expect(result.auction, isNotNull);
      expect(result.choices, isNull);
    });

    test('should return VehicleData with choices when response code is 300',
        () async {
      // arrange
      setUpMockHttpClientSuccess300();

      // act
      final result =
          await dataSource.getVehicleData(userId: userId, vin: vin);

      // assert
      expect(result.auction, isNull);
      expect(result.choices, isNotNull);
      expect(result.choices!.length, equals(2));
    });

    test('should throw appropriate exception when response code is an error',
        () async {
      // arrange
      setUpMockHttpClientError();

      // act & assert
      expect(
        () => dataSource.getVehicleData(userId: userId, vin: vin),
        throwsA(isA<Failure>()),
      );
    });
  });
}
