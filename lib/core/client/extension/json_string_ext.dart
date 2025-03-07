// lib/core/utils/json_utils.dart
import 'dart:convert';

import 'package:car_challenge/core/client/extension/fixer_strategy/json_fixer.dart';
import 'package:car_challenge/core/client/extension/fixer_strategy/miss_comma_fixer.dart';
import 'package:car_challenge/core/client/extension/fixer_strategy/trailing_coma_array_fixer.dart';

extension JsonStringExtension on String {
  static final List<JsonFixer> _fixers = [
    MissingCommaFixer(),
    TrailingCommaArrayFixer(),
  ];

  /// Validates if the string is correctly formatted JSON.
  bool get isValidJson {
    try {
      jsonDecode(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Attempts to fix common JSON syntax errors (e.g., missing commas) generically.
  String get fixedJson {
    String fixedJson = this;
    for (var fixer in _fixers) {
      if (fixedJson.isValidJson) break;
      fixedJson = fixer.fix(fixedJson);
    }
    return fixedJson;
  }
}
