class TierRange {
  final int tier;
  final int min;
  final int max;

  TierRange({
    required this.tier,
    required this.min,
    required this.max,
  });

  bool isScoreInRange(int score) {
    return min <= score && score <= max;
  }
}
