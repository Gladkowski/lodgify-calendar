import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_recruitment_test/common/time_utils.dart';

void main() {
  group('DateTimeExtension', () {
    group('isSameDay', () {
      test('should return true when dates are the same day', () {
        final date1 = DateTime(2025, 1, 15, 10, 30);
        final date2 = DateTime(2025, 1, 15, 14, 45);

        expect(date1.isSameDay(date2), isTrue);
      });

      test('should return false when dates have different days', () {
        final date1 = DateTime(2025, 1, 15);
        final date2 = DateTime(2025, 1, 16);

        expect(date1.isSameDay(date2), isFalse);
      });

      test('should return false when dates have different months', () {
        final date1 = DateTime(2025, 1, 15);
        final date2 = DateTime(2025, 2, 15);

        expect(date1.isSameDay(date2), isFalse);
      });

      test('should return false when dates have different years', () {
        final date1 = DateTime(2024, 1, 15);
        final date2 = DateTime(2025, 1, 15);

        expect(date1.isSameDay(date2), isFalse);
      });

      test('should return true when dates are exactly the same', () {
        final date1 = DateTime(2025, 1, 15, 12, 30, 47);
        final date2 = DateTime(2025, 1, 15, 12, 30, 47);

        expect(date1.isSameDay(date2), isTrue);
      });

      test('should handle midnight correctly', () {
        final date1 = DateTime(2024, 1, 15, 0, 0, 0);
        final date2 = DateTime(2024, 1, 15, 23, 59, 59);

        expect(date1.isSameDay(date2), isTrue);
      });
    });

    group('isSameMonth', () {
      test('should return true when dates are in the same month', () {
        final date1 = DateTime(2025, 1, 15);
        final date2 = DateTime(2025, 1, 31);

        expect(date1.isSameMonth(date2), isTrue);
      });

      test('should return false when dates have different months', () {
        final date1 = DateTime(2025, 1, 15);
        final date2 = DateTime(2025, 2, 15);

        expect(date1.isSameMonth(date2), isFalse);
      });

      test('should return false when dates have different years', () {
        final date1 = DateTime(2024, 1, 15);
        final date2 = DateTime(2025, 1, 15);

        expect(date1.isSameMonth(date2), isFalse);
      });

      test('should return true when dates are exactly the same', () {
        final date1 = DateTime(2025, 1, 15, 12, 30, 45);
        final date2 = DateTime(2025, 1, 15, 12, 30, 45);

        expect(date1.isSameMonth(date2), isTrue);
      });

      test('should handle leap year February correctly', () {
        final date1 = DateTime(2024, 2, 15);
        final date2 = DateTime(2024, 2, 29);

        expect(date1.isSameMonth(date2), isTrue);
      });
    });
  });
}
