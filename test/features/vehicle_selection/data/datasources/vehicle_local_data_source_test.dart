import 'dart:convert';

import 'package:car_challenge/core/constants/pref_keys.dart';
import 'package:car_challenge/features/user_identification/data/models/user_model.dart';
import 'package:car_challenge/features/vehicle_selection/data/datasources/vehicle_local_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../user_identification/data/datasources/local_data_source_test.mocks.dart';
import '../models/vehicle_auction_model_test.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late VehicleLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = VehicleLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getUser', () {
    final tUserModel = UserModel('test-user-id');
    const tUserJson = '{"id":"test-user-id"}';

    test('should return UserModel when there is one in SharedPreferences', () {
      // arrange
      when(mockSharedPreferences.getString(userKey)).thenReturn(tUserJson);

      // act
      final result = dataSource.getUser();

      // assert
      verify(mockSharedPreferences.getString(userKey));
      expect(result?.id, equals(tUserModel.id));
    });

    test('should return null when there is no user in SharedPreferences', () {
      // arrange
      when(mockSharedPreferences.getString(userKey)).thenReturn(null);

      // act
      final result = dataSource.getUser();

      // assert
      verify(mockSharedPreferences.getString(userKey));
      expect(result, isNull);
    });
  });

  group('getVehicleAuction', () {
    final tVehicleAuctionJson = jsonEncode(tVehicleAuctionModel.toJson());

    test('should return VehicleAuction when there is one in SharedPreferences',
        () async {
      // arrange
      when(mockSharedPreferences.getString(vehicleAuctionKey))
          .thenReturn(tVehicleAuctionJson);

      // act
      final result = await dataSource.getVehicleAuction();

      // assert
      verify(mockSharedPreferences.getString(vehicleAuctionKey));
      expect(result.isRight(), isTrue);
    });

    test(
        'should return a failure when there is no vehicle auction in SharedPreferences',
        () async {
      // arrange
      when(mockSharedPreferences.getString(vehicleAuctionKey)).thenReturn(null);

      // act
      final result = await dataSource.getVehicleAuction();

      // assert
      verify(mockSharedPreferences.getString(vehicleAuctionKey));
      expect(result.isLeft(), isTrue);
    });
  });

  group('saveVehicleAuction', () {
    test('should call SharedPreferences to cache the data', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      // act
      await dataSource.saveVehicleAuction(tVehicleAuctionModel.toEntity());

      // assert
      verify(mockSharedPreferences.setString(
        vehicleAuctionKey,
        any,
      ));
    });
  });
}
