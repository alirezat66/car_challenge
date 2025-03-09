import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:user_identification/user_identification.dart';

void main() {
  group('UserModel', () {
    const tUserId = 'test-user-id';
    final tUserModel = UserModel(tUserId);

    test('should be a subclass of User entity', () {
      // assert
      expect(tUserModel, isA<User>());
    });

    group('fromJson', () {
      test('should return a valid model when the JSON has a valid id', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': tUserId,
        };

        // act
        final result = UserModel.fromJson(jsonMap);

        // assert
        expect(result.id, equals(tUserModel.id));
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () {
        // act
        final result = tUserModel.toJson();

        // assert
        final expectedJsonMap = {
          'id': tUserId,
        };
        expect(result, equals(expectedJsonMap));
      });
    });

    test('should correctly handle JSON serialization and deserialization', () {
      // act - full cycle of serialization and deserialization
      final jsonString = jsonEncode(tUserModel.toJson());
      final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final result = UserModel.fromJson(decodedJson);

      // assert
      expect(result.id, equals(tUserModel.id));
    });
  });
}
