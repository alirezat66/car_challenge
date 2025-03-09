import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:vehicle_selection/src/data/models/auction_model.dart';
import 'package:vehicle_selection/vehicle_search.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final BaseClient httpClient;

  SearchRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<Either<Failure, SearchResult>> search(String userId,
      {String? vin, String? externalId}) async {
    final headers = {
      CosChallenge.user: userId,
      if (vin != null) 'vin': vin, // Optional VIN header
      if (externalId != null)
        'externalId': externalId, // Optional externalId header
    };

    try {
      final response = await httpClient.get(
        Uri.https('anyUrl', '/vehicle'), // Arbitrary URL, as per challenge
        headers: headers,
      );

      switch (response.statusCode) {
        case 200:
          final responseString = response.body.isValidJson
              ? response.body
              : response.body.fixedJson;
          final json = jsonDecode(responseString) as Map<String, dynamic>;
          final auctionModel = AuctionModel.fromJson(json);
          return Right(SearchResult(auction: auctionModel.toEntity()));

        case 300:
          final json = jsonDecode(response.body) as List<dynamic>;
          final choices = json
              .map((item) =>
                  VehicleChoiceModel.fromJson(item as Map<String, dynamic>))
              .map((model) => model.toEntity())
              .toList();
          return Right(SearchResult(choices: choices));

        default:
          final errorData = jsonDecode(response.body) as Map<String, dynamic>;
          final errorKey = errorData['msgKey'] as String? ?? 'unknown_error';
          return Left( FailureFactory.createFailure(
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
}
