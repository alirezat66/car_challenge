import 'package:car_challenge/core/client/extension/fixer_strategy/json_fixer.dart';

// Fixer for adding missing commas between key-value pairs
class MissingCommaFixer implements JsonFixer {
  @override
  String fix(String json) {
    // Regex to find missing commas between key-value pairs
    return json.replaceAllMapped(
      RegExp(r'(".*?")\s*("[^"]+":)'),
      (match) => '${match.group(1)}, ${match.group(2)}',
    );
  }
}
