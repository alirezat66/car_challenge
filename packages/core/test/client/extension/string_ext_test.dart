// test/core/utils/json_utils_test.dart
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JsonStringExtension', () {
    // Tests for isValidJson
    group('isValidJson', () {
      test('valid simple object', () {
        const json = '{"name": "John", "age": 30}';
        expect(json.isValidJson, isTrue);
      });

      test('valid empty object', () {
        const json = '{}';
        expect(json.isValidJson, isTrue);
      });

      test('valid empty array', () {
        const json = '[]';
        expect(json.isValidJson, isTrue);
      });

      test('valid nested object', () {
        const json = '{"person": {"name": "John", "age": 30}}';
        expect(json.isValidJson, isTrue);
      });

      test('valid array with mixed types', () {
        const json = '[1, "two", true, null]';
        expect(json.isValidJson, isTrue);
      });

      test('invalid - missing comma', () {
        const json = '{"name": "John" "age": 30}';
        expect(json.isValidJson, isFalse);
      });

      test('invalid - missing closing brace', () {
        const json = '{"name": "John"';
        expect(json.isValidJson, isFalse);
      });

      test('invalid - unquoted key', () {
        const json = '{name: "John"}';
        expect(json.isValidJson, isFalse);
      });

      test('invalid - trailing comma in object', () {
        const json = '{"name": "John",}';
        expect(json.isValidJson, isFalse);
      });

      test('invalid - empty string', () {
        const json = '';
        expect(json.isValidJson, isFalse);
      });
    });

    // Tests for fixedJson
    group('fixedJson', () {
      test('valid JSON - no change', () {
        const json = '{"name": "John", "age": 30}';
        expect(json.fixedJson, equals(json));
        expect(json.fixedJson.isValidJson, isTrue);
      });

      test('missing comma between key-value pairs', () {
        const invalidJson = '{"name": "John" "age": 30}';
        final fixed = invalidJson.fixedJson;
        expect(fixed.isValidJson, isTrue);
      });

      test('missing comma in nested object', () {
        const invalidJson = '{"person": {"name": "John" "age": 30}}';
        final fixed = invalidJson.fixedJson;
        expect(fixed.isValidJson, isTrue);
      });

      test('trailing comma in array', () {
        const invalidJson = '[1, 2, 3,]';
        final fixed = invalidJson.fixedJson;
        expect(fixed.isValidJson, isTrue);
      });

      test('CosChallenge _success response', () {
        const invalidJson = '''
        {
          "id": 123,
          "feedback": "Please modify the price.",
          "valuatedAt": "2023-01-05T14:08:40.456Z",
          "requestedAt": "2023-01-05T14:08:40.456Z",
          "createdAt": "2023-01-05T14:08:40.456Z",
          "updatedAt": "2023-01-05T14:08:42.153Z",
          "make": "Toyota",
          "model": "GT 86 Basis",
          "externalId": "DE003-018601450020008"
          "_fk_sellerUser": "25475e37-6973-483b-9b15-cfee721fc29f",
          "price": 500,
          "positiveCustomerFeedback": true,
          "_fk_uuid_auction": "3e255ad2-36d4-4048-a962-5e84e27bfa6e",
          "inspectorRequestedAt": "2023-01-05T14:08:40.456Z",
          "origin": "AUCTION",
          "estimationRequestId": "3a295387d07f"
        }
        ''';
        final fixed = invalidJson.fixedJson;
        expect(fixed.isValidJson, isTrue);
        expect(
            fixed.contains('"externalId": "DE003-018601450020008",'), isTrue);
        expect(
            fixed.contains(
                '"_fk_sellerUser": "25475e37-6973-483b-9b15-cfee721fc29f"'),
            isTrue);
      });

      test('string with comma inside quotes - no change', () {
        const validJson = '{"text": "hello, world", "value": 42}';
        final fixed = validJson.fixedJson;
        expect(fixed, equals(validJson));
        expect(fixed.isValidJson, isTrue);
      });

      test('escaped quotes in string - no change', () {
        const validJson = '{"text": "hello \\"world\\""}';
        final fixed = validJson.fixedJson;
        expect(fixed, equals(validJson));
        expect(fixed.isValidJson, isTrue);
      });

      test('unfixable JSON - returns original', () {
        const unfixableJson = '{"name": "John'; // Missing closing brace
        final fixed = unfixableJson.fixedJson;
        expect(fixed, equals(unfixableJson));
        expect(fixed.isValidJson, isFalse);
      });

      test('whitespace handling', () {
        const invalidJson = '{"name":"John"    "age":30}';
        final fixed = invalidJson.fixedJson;
        expect(fixed.isValidJson, isTrue);
      });

      test('single key-value pair - no comma needed', () {
        const validJson = '{"name": "John"}';
        final fixed = validJson.fixedJson;
        expect(fixed, equals(validJson));
        expect(fixed.isValidJson, isTrue);
      });
    });
  });
}
