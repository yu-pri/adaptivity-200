class ListOrderUtils {
  static List<int> generateRandomOrder(int len) {
    return List.generate(len, (i) => i)..shuffle();
  }

  static Iterable<T> applyOrder<T>(List<T> source, List<int> order) sync* {
    final l = source.length;
    assert(l == order.length);

    for (final orderIndex in order) {
      yield source[orderIndex];
    }
  }
}
