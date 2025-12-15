class CalendarDay {
  const CalendarDay({required this.date, required this.isCurrentMonth, required this.isToday});

  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
}
