class CalendarDay {
  const CalendarDay({required this.date, required this.belongsToSelectedMonth, required this.isToday});

  final DateTime date;
  final bool belongsToSelectedMonth;
  final bool isToday;
}
