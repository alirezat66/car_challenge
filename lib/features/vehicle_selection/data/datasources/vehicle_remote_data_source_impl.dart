import 'dart:async';
import 'dart:convert';

import 'package:car_challenge/core/client/extension/json_string_ext.dart';
import 'package:car_challenge/core/client/snippet.dart';
import 'package:car_challenge/core/error/factory/failure_factory.dart';
import 'package:car_challenge/core/error/failures.dart';
import 'package:car_challenge/features/vehicle_selection/data/datasources/vehicle_remote_data_source.dart';
import 'package:car_challenge/features/vehicle_selection/data/models/vehicle_auction_model.dart';
import 'package:car_challenge/features/vehicle_selection/data/models/vehicle_choice_model.dart';
import 'package:car_challenge/features/vehicle_selection/domain/entities/vehicle_data.dart';
import 'package:http/http.dart';

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final BaseClient httpClient;

  VehicleRemoteDataSourceImpl(this.httpClient);

  @override
  Future<VehicleData> getVehicleData({
    required String userId,
    String? vin,
    String? externalId,
  }) async {
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
          final auctionModel = VehicleAuctionModel.fromJson(json);
          return VehicleData(auction: auctionModel.toEntity());

        case 300:
          final json = jsonDecode(response.body) as List<dynamic>;
          final choices = json
              .map((item) =>
                  VehicleChoiceModel.fromJson(item as Map<String, dynamic>))
              .map((model) => model.toEntity())
              .toList();
          return VehicleData(choices: choices);

        default:
          final errorData = jsonDecode(response.body) as Map<String, dynamic>;
          final errorKey = errorData['msgKey'] as String? ?? 'unknown_error';
          throw FailureFactory.createFailure(
              errorKey: errorKey, data: errorData);
      }
    } on TimeoutException {
      throw NetworkFailure('Request timed out');
    } on ClientException catch (e) {
      throw IdentificationFailure('Authentication error: ${e.message}');
    } on FormatException {
      throw DeserializationFailure('Invalid response format');
    } catch (e) {
      throw UnknownFailure('Unexpected error: $e');
    }
  }
}
