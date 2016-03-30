# range_map

A mapping from disjoint nonempty ranges to values.

## Usage

A simple usage example:

```dart
final range = new Range<int>(3, 5); // 3 inclusive, 5 exclusive
final rangeMap = new TreeRangeMap<int, String>();

rangeMap[range] = 'foo';

print('${rangeMap.containsKey(3)}'); // true
print('${rangeMap[3]}'); // 'foo'

print('${rangeMap.containsKey(4)}'); // true
print('${rangeMap[4]}'); // 'foo'

print('${rangeMap.containsKey(5)}'); // false
print('${rangeMap[5]}'); // null

print('${rangeMap.containsKey(6)}'); // false
print('${rangeMap[6]}'); // null
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/fluidic/range_map/issues
