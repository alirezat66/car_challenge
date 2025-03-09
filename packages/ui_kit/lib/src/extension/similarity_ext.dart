
import 'package:flutter/material.dart';

extension SimilarityExt on int {
  Color get similarityColor {
    if (this >= 80) {
      return Colors.green;
    } else if (this >= 70) {
      return Colors.greenAccent;
    } else if (this >= 60) {
      return Colors.yellow;
    } else if (this >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
