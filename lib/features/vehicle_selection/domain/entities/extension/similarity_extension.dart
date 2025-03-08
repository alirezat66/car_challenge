import 'package:flutter/material.dart';

extension SimilarityExtension on int {
  Color get similarityColor {
    if (this >= 80) {
      return Colors.green; // High similarity
    } else if (this >= 50) {
      return Colors.orange; // Medium similarity
    } else {
      return Colors.red; // Low similarity
    }
  }
}
