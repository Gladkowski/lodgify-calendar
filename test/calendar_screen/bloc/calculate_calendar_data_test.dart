import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_recruitment_test/calendar_screen/bloc/calendar_cubit.dart';
import 'package:mobile_recruitment_test/common/time_utils.dart';

final testDates = [
  // First 7 dates: months starting from Monday to Sunday
  DateTime(2024, 1, 1), // Monday - January 1, 2024 (Monday)
  DateTime(2025, 4, 1), // Tuesday - April 1, 2025 (Tuesday)
  DateTime(2025, 1, 1), // Wednesday - January 1, 2025 (Wednesday)
  DateTime(2025, 5, 1), // Thursday - May 1, 2025 (Thursday)
  DateTime(2024, 3, 1), // Friday - March 1, 2024 (Friday)
  DateTime(2025, 2, 1), // Saturday - February 1, 2025 (Saturday)
  DateTime(2024, 12, 1), // Sunday - December 1, 2024 (Sunday)
  // Dates with specific day numbers
  DateTime(2025, 2, 28), // February 28, 2025 - non-leap year
  DateTime(2024, 2, 29), // February 29, 2024 - leap year
  DateTime(2025, 11, 30), // November 30, 2025 - 30 days month
  DateTime(2025, 12, 31), // December 31, 2025 - 31 days month
];

void main() {
  group('calculateCalendarData', () {
    late CalendarCubit cubit;

    setUp(() {
      cubit = CalendarCubit();
    });

    tearDown(() {
      cubit.close();
    });

    /////////////////////////////////////////
    /// Basic structure
    /////////////////////////////////////////
    group('basic structure', () {
      test('should return exactly 42 days (6 weeks)', () {
        for (final selectedDate in testDates) {
          final calendarDays = cubit.calculateCalendarData(selectedDate);

          expect(calendarDays.length, calendarNumberOfDays);
        }
      });

      test('should always start on Monday', () {
        for (final selectedDate in testDates) {
          final calendarDays = cubit.calculateCalendarData(selectedDate);

          expect(calendarDays.first.date.weekday, DateTime.monday);
        }
      });

      test('should have sequential days without gaps', () {
        for (final selectedDate in testDates) {
          final calendarDays = cubit.calculateCalendarData(selectedDate);

          for (int i = 1; i < calendarDays.length; i++) {
            final previousDate = calendarDays[i - 1].date;
            final currentDate = calendarDays[i].date;
            final expectedNextDate = previousDate.add(const Duration(days: 1));

            expect(currentDate.isSameDay(expectedNextDate), isTrue);
          }
        }
      });
    });

    /////////////////////////////////////////
    /// Selected month related
    /////////////////////////////////////////
    group('belongsToSelectedMonth flag', () {
      test('should handle all 12 months correctly (non-leap year)', () {
        final months = [
          (1, 31), // January
          (2, 28), // February (non-leap year)
          (3, 31), // March
          (4, 30), // April
          (5, 31), // May
          (6, 30), // June
          (7, 31), // July
          (8, 31), // August
          (9, 30), // September
          (10, 31), // October
          (11, 30), // November
          (12, 31), // December
        ];

        for (final (month, expectedDays) in months) {
          final selectedDate = DateTime(2025, month, 15);
          final calendarDays = cubit.calculateCalendarData(selectedDate);

          final daysInMonth = calendarDays.where((day) => day.belongsToSelectedMonth).length;
          expect(daysInMonth, expectedDays, reason: 'Month $month should have $expectedDays days');
        }
      });

      test('should handle all 12 months correctly (leap year)', () {
        final months = [
          (1, 31), // January
          (2, 29), // February (leap year)
          (3, 31), // March
          (4, 30), // April
          (5, 31), // May
          (6, 30), // June
          (7, 31), // July
          (8, 31), // August
          (9, 30), // September
          (10, 31), // October
          (11, 30), // November
          (12, 31), // December
        ];

        for (final (month, expectedDays) in months) {
          final selectedDate = DateTime(2024, month, 15);
          final calendarDays = cubit.calculateCalendarData(selectedDate);

          final daysInMonth = calendarDays.where((day) => day.belongsToSelectedMonth).length;
          expect(daysInMonth, expectedDays, reason: 'Month $month should have $expectedDays days');
        }
      });

      test('should include days from previous year at the start', () {
        // January 1, 2023 is Sunday, so calendar starts on Monday, December 26, 2022
        final selectedDate = DateTime(2023, 1, 15);
        final calendarDays = cubit.calculateCalendarData(selectedDate);

        // December 26, 2022, Monday
        final firstDay = calendarDays.first.date;
        expect(firstDay.year, 2022);
        expect(firstDay.month, 12);
        expect(firstDay.day, 26);
        expect(calendarDays.first.belongsToSelectedMonth, isFalse);
      });

      test('should include days from next month at the end', () {
        // December 1, 2024 is Sunday, calendar starts on November 25, 2024
        final selectedDate = DateTime(2024, 12, 1);
        final calendarDays = cubit.calculateCalendarData(selectedDate);

        // January 5, 2025, Sunday
        final lastDay = calendarDays.last.date;
        expect(lastDay.year, 2025);
        expect(lastDay.month, 1);
        expect(lastDay.day, 5);
        expect(calendarDays.last.belongsToSelectedMonth, isFalse);
      });

      test('should have no previous-month days when month starts on Monday', () {
        // January 1, 2024 is Monday, so calendar should start exactly on this date
        final selectedDate = DateTime(2024, 1, 15);
        final calendarDays = cubit.calculateCalendarData(selectedDate);

        // January 1, 2024, Monday
        final firstDay = calendarDays.first.date;
        expect(firstDay.year, 2024);
        expect(firstDay.month, 1);
        expect(firstDay.day, 1);
        expect(calendarDays.first.belongsToSelectedMonth, isTrue);
      });

      test('should always include at least one next-month day at the end', () {
        // For a 6x7 grid (42 cells) there is always at least one day from the next month
        for (int month = 1; month <= 12; month++) {
          final selectedDate = DateTime(2024, month, 15);
          final calendarDays = cubit.calculateCalendarData(selectedDate);

          expect(calendarDays.last.belongsToSelectedMonth, isFalse);
        }
      });
    });

    /////////////////////////////////////////
    /// Today related
    /////////////////////////////////////////
    group('isToday flag', () {
      test('should mark current day as today', () {
        final now = DateTime.now();
        final calendarDays = cubit.calculateCalendarData(now);

        final todayDays = calendarDays.where((day) => day.isToday).toList();
        expect(todayDays.length, lessThanOrEqualTo(1));

        expect(todayDays.isNotEmpty, isTrue);
        expect(todayDays.length, 1);
        expect(todayDays.first.date.isSameDay(now), isTrue);
      });
    });

    /////////////////////////////////////////
    /// Weekdays related
    /////////////////////////////////////////
    group('different weekdays for first day of month', () {
      test('should handle month starting on Monday', () {
        // January 1, 2024 is Monday
        final selectedDate = DateTime(2024, 1, 15);
        final calendarDays = cubit.calculateCalendarData(selectedDate);

        expect(calendarDays.first.date.isSameDay(DateTime(2024, 1, 1)), isTrue);
        expect(calendarDays.first.belongsToSelectedMonth, isTrue);
      });

      test('should handle month starting on Sunday', () {
        // December 1, 2024 is Sunday
        final selectedDate = DateTime(2024, 12, 15);
        final calendarDays = cubit.calculateCalendarData(selectedDate);

        // Calendar should start on previous Monday (November 25)
        expect(calendarDays.first.date.isSameDay(DateTime(2024, 11, 25)), isTrue);
        expect(calendarDays.first.belongsToSelectedMonth, isFalse);
      });

      test('should handle month starting on Saturday', () {
        // February 1, 2025 is Saturday
        final selectedDate = DateTime(2025, 2, 15);
        final calendarDays = cubit.calculateCalendarData(selectedDate);

        // Calendar should start on previous Monday (January 27)
        expect(calendarDays.first.date.isSameDay(DateTime(2025, 1, 27)), isTrue);
        expect(calendarDays.first.belongsToSelectedMonth, isFalse);
      });

      test('should handle month starting on Wednesday', () {
        // January 1, 2025 is Wednesday
        final selectedDate = DateTime(2025, 1, 15);
        final calendarDays = cubit.calculateCalendarData(selectedDate);

        // Calendar should start on previous Monday (December 30, 2024)
        expect(calendarDays.first.date.isSameDay(DateTime(2024, 12, 30)), isTrue);
        expect(calendarDays.first.belongsToSelectedMonth, isFalse);
      });
    });
  });

  /////////////////////////////////////////
  /// TimeZone related
  /////////////////////////////////////////

  group('timezone behavior', () {
    late CalendarCubit cubit;

    setUp(() {
      cubit = CalendarCubit();
    });

    tearDown(() {
      cubit.close();
    });

    // test('calculateCalendarData should be stable around UTC/local midnight edge case', () {

    // });
  });
}
