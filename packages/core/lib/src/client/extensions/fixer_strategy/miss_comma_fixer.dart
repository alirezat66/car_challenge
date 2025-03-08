
// Fixer for adding missing commas between key-value pairs
import 'package:core/src/client/extensions/fixer_strategy/json_fixer.dart';

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
