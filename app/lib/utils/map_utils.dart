class MapUtils {
  static Map<String, V> toCaseInsensitive<V>(Map<String, V> map) {
    return map.entries.fold<Map<String, V>>(<String, V>{}, (map, item) {
      map[item.key.toLowerCase()] = item.value;
      return map;
    });
  }

  static Map<K, V> fromList<T, K, V>(
      List<T> items, K Function(T) keySelector, V Function(T) valSelector) {
    return items.fold(<K, V>{}, (map, item) {
      map[keySelector(item)] = valSelector(item);
      return map;
    });
  }
}
