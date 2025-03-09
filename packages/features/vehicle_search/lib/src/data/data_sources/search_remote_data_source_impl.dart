import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:vehicle_selection/src/data/data_sources/search_remote_data_source.dart';
import 'package:vehicle_selection/src/data/models/vehicle_choice_model.dart';
import 'package:vehicle_selection/src/domain/entities/search_result.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final BaseClient httpClient;

  SearchRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<Either<Failure, SearchResult>> searchByVin(
      String userId, String vin) async {
    final headers = {
      'user': userId,
      'vin': vin,
    };

    try {
      final response = await httpClient.get(
        Uri.https('anyUrl', '/vehicle'),
        headers: headers,
      );

      String responseBody = response.body;

      // Use your JSON fixing utilities for handling malformed JSON
      if (!responseBody.isValidJson) {
        responseBody = responseBody.fixedJson;
      }

      switch (response.statusCode) {
        case 200:
          final json = jsonDecode(responseBody) as Map<String, dynamic>;
          final externalId = json['externalId'] as String;
          return Right(SearchResult(selectedExternalId: externalId));

        case 300:
          final jsonList = jsonDecode(responseBody) as List<dynamic>;
          final choices = jsonList
              .map((item) =>
                  VehicleChoiceModel.fromJson(item as Map<String, dynamic>))
              .map((model) => model.toEntity())
              .toList();
          return Right(SearchResult(choices: choices));

        default:
          final errorData = jsonDecode(responseBody) as Map<String, dynamic>;
          final errorKey = errorData['msgKey'] as String? ?? 'server_error';
          return Left(FailureFactory.createFailure(
              errorKey: errorKey, data: errorData));
      }
    } on TimeoutException {
      return Left(FailureFactory.networkFailure('Request timed out'));
    } on ClientException catch (e) {
      return Left(FailureFactory.authenticationFailure(
          'Authentication error: ${e.message}'));
    } on FormatException {
      return Left(
          FailureFactory.deserializationFailure('Invalid response format'));
    } catch (e) {
      return Left(FailureFactory.unknownFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> selectVehicleOption(
      String userId, String externalId) async {
    final headers = {
      'user': userId,
      'externalId': externalId,
    };

    try {
      final response = await httpClient.get(
        Uri.https('anyUrl', '/select'),
        headers: headers,
      );

      String responseBody = response.body;
      if (!responseBody.isValidJson) {
        responseBody = responseBody.fixedJson;
      }

      if (response.statusCode == 200) {
        final json = jsonDecode(responseBody) as Map<String, dynamic>;
        return Right(json['_fk_uuid_auction'] as String);
      } else {
        final errorData = jsonDecode(responseBody) as Map<String, dynamic>;
        final errorKey = errorData['msgKey'] as String? ?? 'server_error';
        return Left(
            FailureFactory.createFailure(errorKey: errorKey, data: errorData));
      }
    } on TimeoutException {
      return Left(FailureFactory.networkFailure('Request timed out'));
    } on ClientException catch (e) {
      return Left(FailureFactory.authenticationFailure(
          'Authentication error: ${e.message}'));
    } on FormatException {
      return Left(
          FailureFactory.deserializationFailure('Invalid response format'));
    } catch (e) {
      return Left(FailureFactory.unknownFailure(e));
    }
  }
}
