// Fixer for handling trailing commas in arrays

import 'package:core/src/client/extensions/fixer_strategy/json_fixer.dart';

class TrailingCommaArrayFixer implements JsonFixer {
  @override
  String fix(String json) {
    // Remove trailing commas in arrays
    return json.replaceAll(RegExp(r',\s*(?=\])'), '');
  }
}
