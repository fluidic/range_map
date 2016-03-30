library range_map.range_map;

import 'package:quiver_hashcode/hashcode.dart';

import 'range.dart';

class Entry<K, V> {
  final K key;
  final V value;

  const Entry(this.key, this.value);

  @override
  bool operator ==(o) => o is Entry && o.key == key && o.value == value;

  @override
  int get hashCode => hash2(key.hashCode, value.hashCode);
}

/// A mapping from disjoint nonempty ranges to non-null values.
/// Queries look up the value associated with the range (if any)
/// that contains a specified key.
abstract class RangeMap<C extends Comparable, V> {
  /// Returns the range containing this key and its associated value,
  /// if such a range is present in the range map, or null otherwise
  Entry<Range<C>, V> getEntry(C key);

  /// Returns true if this map contains the given [value].
  ///
  /// Returns true if any of the values in the map are equal to `value`
  /// according to the `==` operator.
  bool containsValue(Object value);

  /// Returns true if this map contains the given [key].
  ///
  /// Returns true if any of the keys in the map are equal to `key`
  /// according to the equality used by the map.
  bool containsKey(C key);

  /// Removes all associations from this range map.
  void clear();

  /// Applies [f] to each key-value pair of the map.
  /// Calling `f` must not add or remove keys from the map.
  void forEach(void f(Range<C> key, V value));

  /// Returns the value associated with the specified key,
  /// or null if there is no such value.
  V operator [](C key);

  /// Maps a range to a specified value.
  void operator []=(Range<C> key, V value);

  /// Adds all key-value pairs of [other] to this map.
  ///
  /// If a key of [other] is already in this map, its value is overwritten.
  ///
  /// The operation is equivalent to doing `this[key] = value` for each key
  /// and associated value in other. It iterates over [other], which must
  /// therefore not change during the iteration.
  void addAll(RangeMap<C, V> other);

  /// Removes all associations from this range map in the specified range
  ///
  /// If !range.containsKey(key), this[key] will return the same result before
  /// and after a call to remove(range). If range.containsKey(key), then after
  /// a call to remove(range), this[key] will return `null`.
  void remove(Range<C> rangeToRemove);

  /// The keys of [this].
  ///
  /// The order of iteration is defined by the individual `Map` implementation,
  /// but must be consistent between changes to the map.
  Iterable<Range<C>> get keys;

  /// The values of [this].
  ///
  /// The values are iterated in the order of their corresponding keys.
  /// This means that iterating [keys] and [values] in parallel will
  /// provided matching pairs of keys and values.
  Iterable<V> get values;

  /// The number of key-value pairs in the map.
  int get length;

  /// Returns true if there is no key-value pair in the map.
  bool get isEmpty;

  /// Returns true if there is at least one key-value pair in the map.
  bool get isNotEmpty;
}
