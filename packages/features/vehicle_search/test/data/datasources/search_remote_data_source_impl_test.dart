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

  group('search', () {
    // Test Auction response (status code 200)
    test('should return SearchResult with auction when status is 200',
        () async {
      // Arrange
      final headers = {
        CosChallenge.user: testUserId,
        'vin': testVin,
      };

      final successResponse = {
        'id': 12345,
        'feedback': 'Good condition',
        'valuatedAt': '2023-01-01T10:00:00Z',
        'requestedAt': '2023-01-01T09:00:00Z',
        'createdAt': '2023-01-01T08:00:00Z',
        'updatedAt': '2023-01-01T11:00:00Z',
        'make': 'Toyota',
        'model': 'GT 86',
        'externalId': testExternalId,
        '_fk_sellerUser': 'user123',
        'price': 25000,
        'positiveCustomerFeedback': true,
        '_fk_uuid_auction': 'auction-123',
        'inspectorRequestedAt': '2023-01-01T09:30:00Z',
        'origin': 'dealer',
        'estimationRequestId': 'est123'
      };

      when(mockHttpClient.get(any, headers: headers)).thenAnswer(
          (_) async => http.Response(jsonEncode(successResponse), 200));

      // Act
      final result = await dataSource.search(testUserId, vin: testVin);

      // Assert
      expect(result, isA<Right<Failure, SearchResult>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (searchResult) {
          expect(searchResult.auction, isNotNull);
          expect(searchResult.auction!.make, equals('Toyota'));
          expect(searchResult.auction!.model, equals('GT 86'));
          expect(searchResult.auction!.externalId, equals(testExternalId));
          expect(searchResult.choices, isNull);
        },
      );
      verify(mockHttpClient.get(any, headers: headers));
    });

    // Test Multiple Choices response (status code 300)
    test('should return SearchResult with choices when status is 300',
        () async {
      // Arrange
      final headers = {
        CosChallenge.user: testUserId,
        'vin': testVin,
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

      when(mockHttpClient.get(any, headers: headers)).thenAnswer(
          (_) async => http.Response(jsonEncode(multipleChoicesResponse), 300));

      // Act
      final result = await dataSource.search(testUserId, vin: testVin);

      // Assert
      expect(result, isA<Right<Failure, SearchResult>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (searchResult) {
          expect(searchResult.auction, isNull);
          expect(searchResult.choices, isNotNull);
          expect(searchResult.choices!.length, equals(2));
          expect(searchResult.choices!.first.externalId, equals('choice-id-1'));
        },
      );
      verify(mockHttpClient.get(any, headers: headers));
    });

    // Test Error response
    test('should return Failure when status is not 200 or 300', () async {
      // Arrange
      final headers = {
        CosChallenge.user: testUserId,
        'vin': testVin,
      };

      final errorResponse = {
        'msgKey': 'maintenance',
        'params': {'delaySeconds': '5'},
        'message': 'Please try again in 5 seconds',
      };

      when(mockHttpClient.get(any, headers: headers)).thenAnswer(
          (_) async => http.Response(jsonEncode(errorResponse), 400));

      // Act
      final result = await dataSource.search(testUserId, vin: testVin);

      // Assert
      expect(result, isA<Left<Failure, SearchResult>>());
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Should not return success'),
      );
      verify(mockHttpClient.get(any, headers: headers));
    });

    // Test with external ID
    test('should use externalId in headers when provided', () async {
      // Arrange
      final headers = {
        CosChallenge.user: testUserId,
        'externalId': testExternalId,
      };

      final successResponse = {
        'id': 12345,
        'feedback': 'Good condition',
        'valuatedAt': '2023-01-01T10:00:00Z',
        'requestedAt': '2023-01-01T09:00:00Z',
        'createdAt': '2023-01-01T08:00:00Z',
        'updatedAt': '2023-01-01T11:00:00Z',
        'make': 'Toyota',
        'model': 'GT 86',
        'externalId': testExternalId,
        '_fk_sellerUser': 'user123',
        'price': 25000,
        'positiveCustomerFeedback': true,
        '_fk_uuid_auction': 'auction-123',
        'inspectorRequestedAt': '2023-01-01T09:30:00Z',
        'origin': 'dealer',
        'estimationRequestId': 'est123'
      };

      when(mockHttpClient.get(any, headers: headers)).thenAnswer(
          (_) async => http.Response(jsonEncode(successResponse), 200));

      // Act
      final result =
          await dataSource.search(testUserId, externalId: testExternalId);

      // Assert
      expect(result, isA<Right<Failure, SearchResult>>());
      verify(mockHttpClient.get(any, headers: headers));
    });

    // Test exception handling
    test('should handle invalid JSON response', () async {
      // Arrange
      final headers = {
        CosChallenge.user: testUserId,
        'vin': testVin,
      };

      when(mockHttpClient.get(any, headers: headers))
          .thenAnswer((_) async => http.Response('{"invalid json', 200));

      // Act
      final result = await dataSource.search(testUserId, vin: testVin);

      // Assert
      expect(result, isA<Left<Failure, SearchResult>>());
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Should not return success'),
      );
      verify(mockHttpClient.get(any, headers: headers));
    });

    test('should handle network exceptions', () async {
      // Arrange
      final headers = {
        CosChallenge.user: testUserId,
        'vin': testVin,
      };

      when(mockHttpClient.get(any, headers: headers))
          .thenThrow(http.ClientException('Network error'));

      // Act
      final result = await dataSource.search(testUserId, vin: testVin);

      // Assert
      expect(result, isA<Left<Failure, SearchResult>>());
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Should not return success'),
      );
      verify(mockHttpClient.get(any, headers: headers));
    });
  });
}
