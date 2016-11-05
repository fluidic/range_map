import 'package:range_map/range_map.dart';
import 'package:test/test.dart';

void main() {
  group('Range tests', () {
    test('isEmpty', () {
      final range = new Range<int>(0, 0);
      expect(range.isEmpty, isTrue);
    });

    test('isNotEmpty', () {
      final range = new Range<int>(0, 1);
      expect(range.isNotEmpty, isTrue);
    });

    test('throws an ArgumentError when start > end', () {
      expect(() => new Range<int>(2, 1), throwsArgumentError);
    });

    test('contains()', () {
      final range = new Range<int>(0, 2);
      expect(range.contains(1), isTrue);
      expect(range.contains(2), isFalse);
    });

    test('intersection()', () {
      final range1 = new Range<int>(1, 5);
      final range2 = new Range<int>(3, 7);
      expect(range1.intersection(range2), equals(new Range(3, 5)));

      final range3 = new Range<int>(1, 3);
      final range4 = new Range<int>(5, 7);
      expect(range3.intersection(range4), isNull);

      final range5 = new Range<int>(1, 3);
      final range6 = new Range<int>(3, 5);
      expect(range5.intersection(range6), new Range(3, 3));

      final range7 = new Range<int>(1, 1);
      final range8 = new Range<int>(1, 1);
      expect(range7.intersection(range8), new Range(1, 1));
    });

    test('toString()', () {
      final range = new Range<int>(0, 2);
      expect(range.toString(), equals('[0..2)'));
    });

    test('A range can be used as a map key', () {
      final range = new Range<int>(0, 2);
      final map = {range: true};
      expect(map[new Range<int>(0, 2)], isTrue);
    });

    test('equality', () {
      final range1 = new Range<int>(0, 2);
      final range2 = new Range<int>(0, 2);
      expect(range1, equals(range2));
    });
  });
}
