library range_map.range;

import 'package:quiver_hashcode/hashcode.dart';

/// An immutable range of objects from [start] inclusive to [end] exclusive.
///
/// The objects need to be implementations of [Comparable].
class Range<C extends Comparable> {
  /// Start value in this [Range].
  final C start;

  /// End value in this [Range].
  final C end;

  /// Returns a [Range] that contains all values greater than or equal to
  /// [start] and strictly less than [end].
  Range(this.start, this.end) {
    if (start.compareTo(end) > 0) {
      throw new ArgumentError('start is greater than end');
    }
  }

  /// Returns `true` if there are no objects in this [Range].
  bool get isEmpty => start.compareTo(end) == 0;

  /// Returns `true` if there is at least one element in this [Range].
  bool get isNotEmpty => !isEmpty;

  /// Returns `true` if value is within the bounds of this range.
  /// For example, on the range [0..2), contains(1) returns `true`,
  /// while contains(2) returns `false`.
  bool contains(C value) =>
      value.compareTo(start) >= 0 && value.compareTo(end) < 0;

  @override
  String toString() => '[$start..$end)';

  @override
  bool operator ==(o) => o is Range && o.start == start && o.end == end;

  @override
  int get hashCode => hash2(start.hashCode, end.hashCode);

  /// Returns the maximal range enclosed by both this range and [other],
  /// if such a range exists.
  ///
  /// For example, the intersection of [1..5) and [3..7) is [3..5).
  /// The resulting range may be empty; for example, [1..5) intersected
  /// with [5..7) yields the empty range [5..5).
  ///
  /// Returns `null` if no intersection exists.
  Range<C> intersection(Range<C> other) {
    if (end.compareTo(other.start) < 0 || other.end.compareTo(start) < 0) {
      return null;
    } else if (end == other.start) {
      return new Range<C>(end, end);
    } else if (start == other.end) {
      return new Range<C>(start, start);
    }

    return new Range<C>(_max(start, other.start), _min(end, other.end));
  }
}

Comparable _max(Comparable a, Comparable b) => a.compareTo(b) > 0 ? a : b;
Comparable _min(Comparable a, Comparable b) => a.compareTo(b) < 0 ? a : b;
