import 'package:clock/clock.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_recruitment_test/calendar_screen/data/calendar_day.dart';
import 'package:mobile_recruitment_test/common/object_utils.dart';
import 'package:mobile_recruitment_test/common/time_utils.dart';

part 'calendar_cubit.freezed.dart';
part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({Clock clock = const Clock()}) : _clock = clock, super(const CalendarState());

  final Clock _clock;

  void init() {
    final now = _clock.now();
    final calendarDays = calculateCalendarData(now);

    emit(state.copyWith(calendarDays: calendarDays, selectedMonth: now));
  }

  void onPreviousMonthTapped() => state.selectedMonth?.let((selectedMonth) {
    final previousMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);

    final calendarDays = calculateCalendarData(previousMonth);
    emit(state.copyWith(calendarDays: calendarDays, selectedMonth: previousMonth));
  });

  void onNextMonthTapped() => state.selectedMonth?.let((selectedMonth) {
    final nextMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);

    final calendarDays = calculateCalendarData(nextMonth);
    emit(state.copyWith(calendarDays: calendarDays, selectedMonth: nextMonth));
  });

  List<CalendarDay> calculateCalendarData(DateTime selectedDate) {
    // Use UTC for all internal date calculations to avoid DST-related issues
    // (duplicated days when clocks change, e.g. 26 October 2025 in some time zones).
    final firstOfMonthUtc = DateTime.utc(selectedDate.year, selectedDate.month, 1);

    // Weekday returns 1-7, where 1 is Monday. DateTime.monday is 1.
    // As a result we will get how far our first day of the month is from Monday.
    final int offsetToMonday = firstOfMonthUtc.weekday - DateTime.monday;

    // As a result we will get the date that should be displayed in the first cell of the calendar (Monday).
    final startDateUtc = firstOfMonthUtc.subtract(Duration(days: offsetToMonday));

    final now = _clock.now();

    return List.generate(calendarNumberOfDays, (index) {
      // Convert back to local time so that da match the user's local calendar.
      final date = startDateUtc.add(Duration(days: index)).toLocal();

      return CalendarDay(
        date: date,
        belongsToSelectedMonth: date.isSameMonth(selectedDate),
        isToday: date.isSameDay(now),
      );
    });
  }
}

final calendarNumberOfDays = DateTime.daysPerWeek * calendarRowCount;
const calendarRowCount = 6;
