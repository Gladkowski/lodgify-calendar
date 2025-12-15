import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_recruitment_test/calendar_screen/bloc/month_calendar_cubit.dart';
import 'package:mobile_recruitment_test/calendar_screen/month_engine.dart';
import 'package:mobile_recruitment_test/calendar_screen/month_engine_data.dart';
import 'package:mobile_recruitment_test/colors.dart';
import 'package:mobile_recruitment_test/text.dart';
import 'package:mobile_recruitment_test/translations.dart';

/// Main calendar widget that displays a monthly calendar view.
class MonthCalendar extends StatelessWidget {
  const MonthCalendar({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => MonthCalendarCubit()..init(), child: const _Content());
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final monthEngine = MonthEngine();

  CellInfoMapper month = {};

  void resolveCurrentMonth() {
    month = monthEngine.getMonth(DateTime.now());
    setState(() {});
  }

  @override
  void initState() {
    resolveCurrentMonth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MonthCellInfo? firstCell = month[0]?[0];

    return BlocBuilder<MonthCalendarCubit, MonthCalendarState>(
      builder:
          (context, state) => Scaffold(
            body:
                firstCell == null
                    ? const SizedBox()
                    : Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: LText(
                                text: Translations.monthsMap[firstCell.month]!,
                                type: LTextType.medium,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                KMonthEngine.columnCount,
                                (index) => Container(
                                  width: 50.0,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: LText(text: Translations.weekdayMap[index + 1]!, type: LTextType.medium),
                                ),
                              ),
                            ),
                            ...List.generate(
                              KMonthEngine.rowCount,
                              (rowIndex) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  KMonthEngine.columnCount,
                                  (columnIdx) => SizedBox(
                                    width: 50.0,
                                    height: 80.0,
                                    child:
                                        month[rowIndex]![columnIdx]!.isFromThisScope
                                            ? Container(
                                              alignment: Alignment.topCenter,
                                              color: LColors.shade1,
                                              child: LText(
                                                text: month[rowIndex]![columnIdx]!.day.toString(),
                                                type: LTextType.small,
                                                fontWeight:
                                                    month[rowIndex]![columnIdx]!.isToday ? FontWeight.bold : null,
                                              ),
                                            )
                                            : null,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          ),
    );
  }
}
