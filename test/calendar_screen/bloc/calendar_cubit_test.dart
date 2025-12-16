import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_recruitment_test/calendar_screen/bloc/calendar_cubit.dart';
import 'package:mobile_recruitment_test/common/object_utils.dart';
import 'package:mobile_recruitment_test/common/time_utils.dart';

void main() {
  group('CalendarCubit', () {
    test('init should set selectedMonth to now and generate calendarDays', () {
      final now = DateTime(2024, 6, 10, 12, 30);
      final cubit = CalendarCubit(clock: Clock.fixed(now));
      addTearDown(cubit.close);

      cubit.init();

      expect(cubit.state.selectedMonth?.year, now.year);
      expect(cubit.state.selectedMonth?.month, now.month);
      expect(cubit.state.calendarDays, hasLength(calendarNumberOfDays));
      expect(cubit.state.calendarDays.first.date.isSameDay(DateTime(2024, 5, 27)), isTrue);
      expect(cubit.state.calendarDays.last.date.isSameDay(DateTime(2024, 7, 7)), isTrue);
    });

    test('onNextMonthTapped should move December to January (next year)', () {
      final decemberDate = DateTime(2024, 12, 15);
      final cubit = CalendarCubit(clock: Clock.fixed(decemberDate));
      addTearDown(cubit.close);

      cubit
        ..init()
        ..onNextMonthTapped();

      expect(cubit.state.selectedMonth?.year, 2025);
      expect(cubit.state.selectedMonth?.month, DateTime.january);

      final selectedMonthDays = cubit.state.calendarDays.where((d) => d.belongsToSelectedMonth);
      expect(selectedMonthDays.length, 31);
      expect(selectedMonthDays.every((d) => d.date.isSameMonth(decemberDate.add(const Duration(days: 31)))), isTrue);
      expect(cubit.state.calendarDays.first.date.isSameDay(DateTime(2024, 12, 30)), isTrue);
      expect(cubit.state.calendarDays.last.date.isSameDay(DateTime(2025, 2, 9)), isTrue);
    });

    test('onPreviousMonthTapped should move January to December (previous year)', () {
      final januaryDate = DateTime(2025, 1, 15);
      final cubit = CalendarCubit(clock: Clock.fixed(januaryDate));
      addTearDown(cubit.close);

      cubit
        ..init()
        ..onPreviousMonthTapped();

      expect(cubit.state.selectedMonth?.year, 2024);
      expect(cubit.state.selectedMonth?.month, DateTime.december);

      final selectedMonthDays = cubit.state.calendarDays.where((d) => d.belongsToSelectedMonth);
      expect(selectedMonthDays.length, 31);
      expect(selectedMonthDays.every((d) => d.date.isSameMonth(DateTime(2024, 12, 1))), isTrue);
      expect(cubit.state.calendarDays.first.date.isSameDay(DateTime(2024, 11, 25)), isTrue);
      expect(cubit.state.calendarDays.last.date.isSameDay(DateTime(2025, 1, 5)), isTrue);
    });
  });

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
