import 'package:range_map/range_map.dart';
import 'package:test/test.dart';

void main() {
  group('TreeRangeMap tests', () {
    RangeMap<int> map;

    setUp(() {
      map = new TreeRangeMap<int>();
      map[new Range(0, 2)] = 1;
      map[new Range(3, 5)] = 2;
    });

    test('isEmpty', () {
      final emptyMap = new TreeRangeMap<int>();
      expect(emptyMap.isEmpty, isTrue);
    });

    test('isNotEmpty', () {
      expect(map.isNotEmpty, isTrue);
    });

    test('contains()', () {
      expect(map.containsKey(0), isTrue);
      expect(map.containsKey(1), isTrue);
      expect(map.containsKey(2), isFalse);
      expect(map.containsKey(3), isTrue);
      expect(map.containsKey(4), isTrue);
      expect(map.containsKey(5), isFalse);
    });

    test('put', () {
      map[new Range(7, 9)] = 3;
      expect(map[7], equals(3));
    });

    test('put with an overlapping range key', () {
      map[new Range(3, 4)] = 3;
      expect(map[3], equals(3));
      expect(map[4], equals(2));
    });

    test('addAll()', () {
      final newMap = new TreeRangeMap<int>();
      newMap.addAll(map);

      expect(newMap[0], equals(1));
      expect(newMap[1], equals(1));
      expect(newMap[2], isNull);
      expect(newMap[3], equals(2));
      expect(newMap[4], equals(2));
      expect(newMap[5], isNull);
    });

    test('remove()', () {
      map.remove(new Range(1, 4));

      expect(map[0], equals(1));
      expect(map[1], isNull);
      expect(map[2], isNull);
      expect(map[3], isNull);
      expect(map[4], equals(2));
      expect(map[5], isNull);
    });

    test('remove [0, 2)', () {
      map.remove(new Range(0, 2));

      expect(map[0], isNull);
      expect(map[1], isNull);
      expect(map[2], isNull);
      expect(map[3], equals(2));
      expect(map[4], equals(2));
      expect(map[5], isNull);
    });

    test('remove [0, 5)', () {
      map.remove(new Range(0, 5));

      expect(map[0], isNull);
      expect(map[1], isNull);
      expect(map[2], isNull);
      expect(map[3], isNull);
      expect(map[4], isNull);
      expect(map[5], isNull);
    });

    test('remove [2, 3)', () {
      map.remove(new Range(2, 3));

      expect(map[0], equals(1));
      expect(map[1], equals(1));
      expect(map[2], isNull);
      expect(map[3], equals(2));
      expect(map[4], equals(2));
      expect(map[5], isNull);
    });

    test('get', () {
      expect(map[0], equals(1));
      expect(map[1], equals(1));
      expect(map[2], isNull);
      expect(map[3], equals(2));
      expect(map[4], equals(2));
      expect(map[5], isNull);
    });

    test('getEntry()', () {
      expect(map.getEntry(0).value, equals(1));
      expect(map.getEntry(0).key, equals(new Range(0, 2)));
      expect(map.getEntry(1).value, equals(1));
      expect(map.getEntry(1).key, equals(new Range(0, 2)));
      expect(map.getEntry(2), isNull);
    });

    test('keys', () {
      expect(map.keys, orderedEquals([new Range(0, 2), new Range(3, 5)]));
    });

    test('values', () {
      expect(map.values, orderedEquals([1, 2]));
    });

    test('putIfAbsent()', () {
      expect(map.putIfAbsent(new Range(0, 2), () => 3), 1);
      expect(map.putIfAbsent(new Range(7, 9), () => 3), 3);
      expect(map[7], equals(3));
    });

    test('containsValue()', () {
      expect(map.containsValue(1), isTrue);
      expect(map.containsValue(2), isTrue);
      expect(map.containsValue(3), isFalse);
    });

    test('forEach()', () {
      var sum = 0;
      map.forEach((key, value) {
        sum += value;
      });
      expect(sum, equals(3));
    });
  });
}
