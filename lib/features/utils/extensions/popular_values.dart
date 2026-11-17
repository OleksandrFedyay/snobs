// ignore_for_file: always_specify_types
extension MostPopularItemsExtension<E> on Iterable<E> {
  /// Returns the most popular items, where all items in the returned
  /// list have the same number of occurances. If [] is empty, returns an
  /// empty list
  ///
  /// Examples:
  ///   `[1,2,3,2].mostPopularItems() == [2]`
  ///   `[1,1,2,2].mostPopularItems() == [1,2]`
  Iterable<E> mostPopularItems() {
    if (isEmpty) return <E>[];
    final Map<E, int> itemsCounted = <E, int>{};
    for (final e in this) {
      if (itemsCounted.containsKey(e)) {
        itemsCounted[e] = itemsCounted[e]! + 1;
      } else {
        itemsCounted[e] = 1;
      }
    }
    final int length = itemsCounted.values.length;
    if (length < 3) return itemsCounted.keys;

    final int highestCount = (itemsCounted.values.toList()..sort())[length - 3];
    return itemsCounted.entries
        .where((e) => e.value >= highestCount)
        .map((e) => e.key);
  }
}
