import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_recruitment_test/common/object_utils.dart';

void main() {
  group('ObjectExtension', () {
    group('let', () {
      test('should execute operation and return result', () {
        final value = 10;
        final result = value.let((it) => it * 2);

        expect(result, equals(20));
      });

      test('should work with null values', () {
        final int? nullableValue = null;
        final result = nullableValue?.let((it) => it) ?? 99;

        expect(result, equals(99));
      });
    });
  });
}
