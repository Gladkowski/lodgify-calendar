import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_recruitment_test/calendar_screen/data/calendar_day.dart';
import 'package:mobile_recruitment_test/common/object_utils.dart';
import 'package:mobile_recruitment_test/common/time_utils.dart';

part 'calendar_cubit.freezed.dart';
part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(const CalendarState());

  void init() {
    _calculateCalendarData(selectedDate: DateTime.now());
  }

  Future<void> _calculateCalendarData({required DateTime selectedDate}) async {
    final firstOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);

    // Weekday returns 1-7, where 1 is Monday. DateTime.monday is 1.
    // As a result we will get how far our first day of the month is from Monday.
    final int offsetToMonday = firstOfMonth.weekday - DateTime.monday;

    // As a result we will get the date that should be displayed in the first cell of the calendar (Monday).
    final startDate = firstOfMonth.subtract(Duration(days: offsetToMonday));

    final calendarDays = List.generate(_numberOfDays, (index) {
      final date = startDate.add(Duration(days: index));

      return CalendarDay(
        date: date,
        isCurrentMonth: date.isSameMonth(selectedDate),
        isToday: date.isSameDay(selectedDate),
      );
    });

    emit(state.copyWith(calendarDays: calendarDays, selectedMonth: selectedDate));
  }

  void onPreviousMonthTapped() => state.selectedMonth?.let((selectedMonth) {
    final previousMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);

    _calculateCalendarData(selectedDate: previousMonth);
  });

  void onNextMonthTapped() => state.selectedMonth?.let((selectedMonth) {
    final nextMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);

    _calculateCalendarData(selectedDate: nextMonth);
  });
}

final _numberOfDays = DateTime.daysPerWeek * _rowCount;
const _rowCount = 6;
