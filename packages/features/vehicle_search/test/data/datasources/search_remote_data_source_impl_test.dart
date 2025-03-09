// test/data/data_sources/search_remote_data_source_impl_test.dart
import 'dart:convert';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vehicle_selection/src/data/data_sources/search_remote_data_source_impl.dart';
import 'package:vehicle_selection/src/domain/entities/search_result.dart';

import 'search_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([http.BaseClient])

void main() {
  late SearchRemoteDataSourceImpl dataSource;
  late MockBaseClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockBaseClient();
    dataSource = SearchRemoteDataSourceImpl(httpClient: mockHttpClient);
  });

  const testUserId = 'test-user-id';
  const testVin = 'TEST12345678901234';
  const testExternalId = 'DE001-018601450020001';

  group('searchByVin', () {
    final testHeaders = {'user': testUserId, 'vin': testVin};
    final successResponse = {
      'id': 12345,
      'make': 'Toyota',
      'model': 'GT 86',
      'externalId': testExternalId,
    };

    final multipleChoicesResponse = [
      {
        'make': 'Toyota',
        'model': 'GT 86',
        'containerName': 'Container 1',
        'similarity': 80,
        'externalId': 'choice-id-1',
      },
      {
        'make': 'Toyota',
        'model': 'GT 86',
        'containerName': 'Container 2',
        'similarity': 60,
        'externalId': 'choice-id-2',
      },
    ];

    final errorResponse = {
      'msgKey': 'maintenance',
      'params': {'delaySeconds': '5'},
      'message': 'Please try again in 5 seconds',
    };

    test(
        'should return SearchResult with selectedExternalId when status is 200',
        () async {
      // Arrange
      when(mockHttpClient.get(any, headers: testHeaders)).thenAnswer(
          (_) async => http.Response(jsonEncode(successResponse), 200));

      // Act
      final result = await dataSource.searchByVin(testUserId, testVin);

      // Assert
      expect(result, isA<Right<Failure, SearchResult>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (searchResult) {
          expect(searchResult.selectedExternalId, equals(testExternalId));
          expect(searchResult.choices, isNull);
        },
      );
      verify(mockHttpClient.get(any, headers: testHeaders));
    });

    test('should return SearchResult with choices when status is 300',
        () async {
      // Arrange
      when(mockHttpClient.get(any, headers: testHeaders)).thenAnswer(
          (_) async => http.Response(jsonEncode(multipleChoicesResponse), 300));

      // Act
      final result = await dataSource.searchByVin(testUserId, testVin);

      // Assert
      expect(result, isA<Right<Failure, SearchResult>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (searchResult) {
          expect(searchResult.selectedExternalId, isNull);
          expect(searchResult.choices, isNotNull);
          expect(searchResult.choices!.length, equals(2));
          expect(searchResult.choices!.first.externalId, equals('choice-id-1'));
        },
      );
      verify(mockHttpClient.get(any, headers: testHeaders));
    });

    test('should return Failure when status is not 200 or 300', () async {
      // Arrange
      when(mockHttpClient.get(any, headers: testHeaders)).thenAnswer(
          (_) async => http.Response(jsonEncode(errorResponse), 400));

      // Act
      final result = await dataSource.searchByVin(testUserId, testVin);

      // Assert
      expect(result, isA<Left<Failure, SearchResult>>());
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
          // You can add more specific checks on the failure type if needed
        },
        (_) => fail('Should not return success'),
      );
      verify(mockHttpClient.get(any, headers: testHeaders));
    });

    test('should handle invalid JSON response', () async {
      // Arrange
      when(mockHttpClient.get(any, headers: testHeaders))
          .thenAnswer((_) async => http.Response('{"invalid json', 200));

      // Act
      final result = await dataSource.searchByVin(testUserId, testVin);

      // Assert
      expect(result, isA<Left<Failure, SearchResult>>());
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Should not return success'),
      );
      verify(mockHttpClient.get(any, headers: testHeaders));
    });

    test('should handle network exceptions', () async {
      // Arrange
      when(mockHttpClient.get(any, headers: testHeaders))
          .thenThrow(http.ClientException('Network error'));

      // Act
      final result = await dataSource.searchByVin(testUserId, testVin);

      // Assert
      expect(result, isA<Left<Failure, SearchResult>>());
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Should not return success'),
      );
      verify(mockHttpClient.get(any, headers: testHeaders));
    });
  });

  group('selectVehicleOption', () {
    final testHeaders = {'user': testUserId, 'externalId': testExternalId};
    final successResponse = {
      'id': 12345,
      'make': 'Toyota',
      'model': 'GT 86',
      '_fk_uuid_auction': 'auction-123',
    };

    final errorResponse = {
      'msgKey': 'maintenance',
      'params': {'delaySeconds': '5'},
      'message': 'Please try again in 5 seconds',
    };

    test('should return auction ID when status is 200', () async {
      // Arrange
      when(mockHttpClient.get(any, headers: testHeaders)).thenAnswer(
          (_) async => http.Response(jsonEncode(successResponse), 200));

      // Act
      final result =
          await dataSource.selectVehicleOption(testUserId, testExternalId);

      // Assert
      expect(result, isA<Right<Failure, String>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (auctionId) {
          expect(auctionId, equals('auction-123'));
        },
      );
      verify(mockHttpClient.get(any, headers: testHeaders));
    });

    test('should return Failure when status is not 200', () async {
      // Arrange
      when(mockHttpClient.get(any, headers: testHeaders)).thenAnswer(
          (_) async => http.Response(jsonEncode(errorResponse), 400));

      // Act
      final result =
          await dataSource.selectVehicleOption(testUserId, testExternalId);

      // Assert
      expect(result, isA<Left<Failure, String>>());
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Should not return success'),
      );
      verify(mockHttpClient.get(any, headers: testHeaders));
    });

    test('should handle invalid JSON response', () async {
      // Arrange
      when(mockHttpClient.get(any, headers: testHeaders))
          .thenAnswer((_) async => http.Response('{"invalid json', 200));

      // Act
      final result =
          await dataSource.selectVehicleOption(testUserId, testExternalId);

      // Assert
      expect(result, isA<Left<Failure, String>>());
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Should not return success'),
      );
      verify(mockHttpClient.get(any, headers: testHeaders));
    });

    test('should handle network exceptions', () async {
      // Arrange
      when(mockHttpClient.get(any, headers: testHeaders))
          .thenThrow(http.ClientException('Network error'));

      // Act
      final result =
          await dataSource.selectVehicleOption(testUserId, testExternalId);

      // Assert
      expect(result, isA<Left<Failure, String>>());
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Should not return success'),
      );
      verify(mockHttpClient.get(any, headers: testHeaders));
    });
  });
}
