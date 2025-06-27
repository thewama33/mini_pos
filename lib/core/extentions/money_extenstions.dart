/// Extension on [num] to provide money formatting
extension MoneyExtension on num {
  /// Returns the number formatted as money string with 2 decimal places
  String get asMoney {
    return toStringAsFixed(2);
  }

  /// Returns the number formatted as currency with symbol
  String asCurrency([String symbol = "L.E"]) {
    if (symbol == "L.E") {
      return '$symbol ${toStringAsFixed(2)}';
    }
    return '$symbol${toStringAsFixed(2)}';
  }

  /// Returns the number formatted as percentage
  String get asPercentage {
    return '${(this * 100).toStringAsFixed(1)}%';
  }
}