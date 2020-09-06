class WrapList<T> {
  WrapList(this.maxItems);
  final int maxItems;
  final _list = <T>[];

  void add(T item) {
    if (_list.length >= maxItems) _list.removeAt(0);
    _list.add(item);
  }

  void clear() {
    _list.clear();
  }

  List<TMap> map<TMap>(TMap Function(T item) mapFn) {
    return _list.map(mapFn).toList();
  }

  T operator [](int index) {
    return _list[index];
  }

  T get latest => _list.last;
  List<T> get list => _list;
  List<T> get reversed => _list.reversed.toList();
}
