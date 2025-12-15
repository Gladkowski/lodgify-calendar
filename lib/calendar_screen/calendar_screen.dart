import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mobile_recruitment_test/calendar_screen/bloc/calendar_cubit.dart';
import 'package:mobile_recruitment_test/calendar_screen/month_engine.dart';
import 'package:mobile_recruitment_test/calendar_screen/month_engine_data.dart';
import 'package:mobile_recruitment_test/common/object_utils.dart';
import 'package:mobile_recruitment_test/ui/buttons/lodgify_icon_button.dart';
import 'package:mobile_recruitment_test/ui/colors.dart';
import 'package:mobile_recruitment_test/ui/typography/text.dart';
import 'package:mobile_recruitment_test/utils/translations.dart';

/// Main calendar screen that displays a monthly calendar view.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => CalendarCubit()..init(), child: const _Content());
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

  //   LodgifyIconButton(
  //   iconData: Icons.chevron_left,
  //   onPressed: () {
  //     // TODO: Implement previous month navigation
  //   },
  // ),

  @override
  Widget build(BuildContext context) {
    final MonthCellInfo? firstCell = month[0]?[0];

    return BlocBuilder<CalendarCubit, CalendarState>(
      builder:
          (context, state) => Scaffold(
            body:
                firstCell == null
                    ? const SizedBox()
                    : Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LText(
                                text:
                                    state.selectedMonth?.let((it) {
                                      final monthName = Translations.monthsMap[it.month] ?? '';
                                      final year = it.year;

                                      return ' $monthName $year';
                                    }) ??
                                    '',
                                type: LTextType.medium,
                                fontWeight: FontWeight.bold,
                              ),
                              const Gap(16),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    Translations.weekDaysEn
                                        .map(
                                          (weekday) => Expanded(
                                            child: Center(child: LText(text: weekday, type: LTextType.medium)),
                                          ),
                                        )
                                        .toList(),
                              ),
                              const Gap(8),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  // 7 days per week
                                  crossAxisCount: DateTime.daysPerWeek,
                                ),
                                itemCount: state.calendarDays.length,
                                itemBuilder: (context, index) {
                                  final calendarDay = state.calendarDays[index];

                                  return Container(
                                    color: calendarDay.isCurrentMonth ? LColors.shade1 : Colors.white,
                                    child: Center(
                                      child: LText(
                                        text: '${calendarDay.date.day}',
                                        type: LTextType.small,
                                        fontWeight: calendarDay.isToday ? FontWeight.bold : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
          ),
    );
  }
}
