part of 'calendar_cubit.dart';

@freezed
abstract class CalendarState with _$CalendarState {
  const factory CalendarState({
    @Default([]) List<CalendarDay> calendarDays,
    DateTime? selectedMonth,
  }) = _CalendarState;
}
