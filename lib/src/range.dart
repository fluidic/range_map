library range_map.range;

import 'dart:collection';
import 'dart:math' show min, max;

import 'package:quiver_hashcode/hashcode.dart';

class Range extends IterableBase<int> {
  final int start;
  final int end;

  /// Returns a [Range] that contains all values greater than or equal to
  /// [start] and strictly less than [end].
  Range(this.start, this.end) {
    if (start < 0) {
      throw new ArgumentError('start is negative');
    }
    if (end < 0) {
      throw new ArgumentError('end is negative');
    }
    if (start > end) {
      throw new ArgumentError('start is greater than end');
    }
  }

  @override
  bool get isEmpty => start == end;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  int get length => end - start;

  @override
  int get first => start;

  @override
  int get last => end - 1;

  /// Returns `true` if value is within the bounds of this range.
  /// For example, on the range [0..2), contains(1) returns `true`,
  /// while contains(2) returns `false`.
  @override
  bool contains(int value) => value >= start && value < end;

  @override
  int elementAt(int index) => start + index;

  @override
  Iterator get iterator =>
      new Iterable.generate(end - start, (x) => x + start).iterator;

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
  Range intersection(Range other) {
    if (end < other.start || other.end < start) {
      return null;
    } else if (end == other.start) {
      return new Range(end, end);
    } else if (start == other.end) {
      return new Range(start, start);
    }

    return new Range(max(start, other.start), min(end, other.end));
  }
}
