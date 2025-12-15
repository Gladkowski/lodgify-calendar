import 'package:flutter/material.dart';

/// Utility class for date and time calculations used in calendar generation.
class TimeUtils {
  TimeUtils._();

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.day == date.day &&
        now.month == date.month &&
        now.year == date.year;
  }

  static int previousMonth({required int month}) {
    return month == 1 ? 12 : month - 1;
  }

  static int previousMonthDays({required int year, required int month}) {
    var year_ = year;
    var month_ = month;
    if (month == 1) {
      year_--;
      month_ = 12;
    }
    return DateUtils.getDaysInMonth(year_, month_);
  }

  static int previousMonthYear({required int month, required int year}) {
    return month == 1 ? year - 1 : year;
  }

  static int daysOffsetPreviousMonthQuantity({
    required int year,
    required int month,
  }) {
    return DateTime(year, month).weekday - 1;
  }

  static List<int> daysOffSetsPreviousMonth({
    required int previousMonthDays,
    required int dayOffSet,
  }) {
    var offsets = <int>[];
    var counter = dayOffSet;
    var previousDays = previousMonthDays;

    while (counter > 0) {
      offsets.add(previousDays);
      previousDays--;
      counter--;
    }

    return offsets.reversed.toList();
  }

  static int nextMonth({required int month}) {
    return month == 12 ? 1 : month + 1;
  }


  static int nextMonthYear({required int month, required int year}) {
    return month == 12 ? year + 1 : year;
  }


  static int getDaysInMonth({required int year, required int month}) {
    return DateUtils.getDaysInMonth(year, month);
  }
}
