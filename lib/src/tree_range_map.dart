library range_map.tree_range_map;

import 'dart:collection';

import 'range_map_base.dart';
import 'range.dart';

class TreeRangeMap<V> implements RangeMap<V> {
  final SplayTreeMap<int, RangeMapEntry<V>> _entriesByLowerBound =
      new SplayTreeMap<int, RangeMapEntry<V>>();

  @override
  Entry<Range, V> getEntry(int key) {
    // lastKeyBefore gets the last key in the map
    // that is strictly smaller than key. Add 1 to key to get
    // the last key that is smaller than or equal to key.
    final lastKey = _entriesByLowerBound.lastKeyBefore(key + 1);
    if (lastKey != null) {
      final entry = _entriesByLowerBound[lastKey];
      return entry.contains(key) ? entry : null;
    } else {
      return null;
    }
  }

  @override
  bool containsValue(Object value) => values.contains(value);

  @override
  bool containsKey(int key) => getEntry(key) != null;

  @override
  void clear() {
    _entriesByLowerBound.clear();
  }

  @override
  void forEach(void f(Range key, V value)) {
    _entriesByLowerBound.forEach((_, entry) {
      f(entry.key, entry.value);
    });
  }

  @override
  V operator [](int key) => getEntry(key)?.value;

  void _putRangeMapEntry(int start, int end, V value) {
    final range = new Range(start, end);
    assert(range.isNotEmpty);
    _entriesByLowerBound[start] = new RangeMapEntry(range, value);
  }

  @override
  void operator []=(Range key, V value) {
    remove(key);
    _putRangeMapEntry(key.start, key.end, value);
  }

  @override
  V putIfAbsent(Range key, V ifAbsent()) {
    final entry = getEntry(key.start);
    if (entry == null) {
      final value = ifAbsent();
      this[key] = value;
      return value;
    } else {
      assert(entry.key == key);
      return entry.value;
    }
  }

  @override
  void addAll(RangeMap<V> other) {
    other.forEach((key, value) {
      this[key] = value;
    });
  }

  @override
  void remove(Range rangeToRemove) {
    if (rangeToRemove.isEmpty) {
      return;
    }

    var key = _entriesByLowerBound.lastKeyBefore(rangeToRemove.start);
    if (key != null) {
      final mapEntryBelowToTruncate = _entriesByLowerBound[key];
      if (mapEntryBelowToTruncate.key.end > rangeToRemove.start) {
        if (mapEntryBelowToTruncate.key.end > rangeToRemove.end) {
          _putRangeMapEntry(rangeToRemove.end, mapEntryBelowToTruncate.end,
              mapEntryBelowToTruncate.value);
        }
        _putRangeMapEntry(mapEntryBelowToTruncate.start, rangeToRemove.start,
            mapEntryBelowToTruncate.value);
      }
    }

    key = _entriesByLowerBound.lastKeyBefore(rangeToRemove.end);
    if (key != null) {
      final mapEntryAboveToTruncate = _entriesByLowerBound[key];
      if (mapEntryAboveToTruncate.end > rangeToRemove.end) {
        _putRangeMapEntry(rangeToRemove.end, mapEntryAboveToTruncate.end,
            mapEntryAboveToTruncate.value);
      }
    }

    while (key != null) {
      final mapEntry = _entriesByLowerBound[key];
      if (mapEntry.start < rangeToRemove.start) {
        break;
      }
      _entriesByLowerBound.remove(mapEntry.start);
      key = _entriesByLowerBound.lastKeyBefore(rangeToRemove.end);
    }
  }

  @override
  Iterable<Range> get keys =>
      _entriesByLowerBound.values.map((entry) => entry.key);

  @override
  Iterable<V> get values =>
      _entriesByLowerBound.values.map((entry) => entry.value);

  @override
  int get length => _entriesByLowerBound.length;

  @override
  bool get isEmpty => _entriesByLowerBound.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;
}
