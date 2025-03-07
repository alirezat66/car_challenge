// Fixer for handling trailing commas in arrays
import 'package:car_challenge/core/client/extension/fixer_strategy/json_fixer.dart';

class TrailingCommaArrayFixer implements JsonFixer {
  @override
  String fix(String json) {
    // Remove trailing commas in arrays
    return json.replaceAll(RegExp(r',\s*(?=\])'), '');
  }
}
