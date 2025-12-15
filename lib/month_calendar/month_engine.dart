import 'package:mobile_recruitment_test/month_calendar/month_engine_data.dart';
import 'package:mobile_recruitment_test/month_calendar/time_utils.dart';

/// This class builds a complete calendar month representation with 42 cells
/// (6 rows × 7 columns), including days from the previous and next months
/// to fill the grid completely.
class MonthEngine {

  var _row = 0;
  var _column = 0;
  var _cell = 0;

  void _moveToNextPositon() {
    _column++;
    if (_column % 7 == 0) {
      _row++;
      _column = 0;
    }
    _cell++;
  }

  void _feedOutput({
    required int day,
    required int month,
    required int year,
    required bool isFromThisScope,
    required CellInfoMapper output,
  }) {
    final date = DateTime(year, month, day);
    final isToday = TimeUtils.isToday(date);

    final cell = {
      _column: MonthCellInfo(
        day: day,
        month: month,
        year: year,
        isFromThisScope: isFromThisScope,
        cell: _cell,
        row: _row,
        column: _column,
        isToday: isToday,
      ),
    };

    if (output[_row] == null) {
      output.addAll({_row: cell});
    } else {
      output[_row]!.addAll(cell);
    }
  }

  void _insertPrevDaysOffset({
    required DateTime date,
    required CellInfoMapper month,
  }) {
    final daysOffset = TimeUtils.daysOffsetPreviousMonthQuantity(
      year: date.year,
      month: date.month,
    );

    if (daysOffset > 0) {
      final previousMonthNumber = TimeUtils.previousMonth(month: date.month);
      final previousMonthYear = TimeUtils.previousMonthYear(
        year: date.year,
        month: date.month,
      );
      final previousMonthDays = TimeUtils.previousMonthDays(
        year: previousMonthYear,
        month: previousMonthNumber,
      );
      final daysOffsetsPreviousMonth = TimeUtils.daysOffSetsPreviousMonth(
        previousMonthDays: previousMonthDays,
        dayOffSet: daysOffset,
      );
      for (var d in daysOffsetsPreviousMonth) {
        _feedOutput(
          day: d,
          month: previousMonthNumber,
          year: previousMonthYear,
          isFromThisScope: false,
          output: month,
        );
        _moveToNextPositon();
      }
    }
  }

  void _insertCurrentMonthDays({
    required DateTime date,
    required CellInfoMapper month,
  }) {
    final daysInMonth = TimeUtils.getDaysInMonth(
      year: date.year,
      month: date.month,
    );
    for (var d = 0; d < daysInMonth; d++) {
      final day = d + 1;
      _feedOutput(
        day: day,
        month: date.month,
        year: date.year,
        isFromThisScope: true,
        output: month,
      );
      _moveToNextPositon();
    }
  }

  void _insertNextDaysOffset({
    required DateTime date,
    required CellInfoMapper month,
  }) {
    final nextMonthNumber = TimeUtils.nextMonth(month: date.month);
    final nextMonthYear = TimeUtils.nextMonthYear(
      year: date.year,
      month: date.month,
    );
    final rest = 42 - _cell;
    for (var d = 0; d <= rest; d++) {
      final day = d + 1;
      _feedOutput(
        day: day,
        month: nextMonthNumber,
        year: nextMonthYear,
        isFromThisScope: false,
        output: month,
      );
      _moveToNextPositon();
    }
  }

  CellInfoMapper getMonth(DateTime date) {
    final CellInfoMapper month = {};
    _insertPrevDaysOffset(date: date, month: month);
    _insertCurrentMonthDays(date: date, month: month);
    _insertNextDaysOffset(date: date, month: month);
    return month;
  }
}
