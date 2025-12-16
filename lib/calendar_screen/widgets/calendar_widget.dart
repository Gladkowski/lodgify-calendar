import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mobile_recruitment_test/calendar_screen/bloc/calendar_cubit.dart';
import 'package:mobile_recruitment_test/common/object_utils.dart';
import 'package:mobile_recruitment_test/ui/buttons/lodgify_icon_button.dart';
import 'package:mobile_recruitment_test/ui/colors.dart';
import 'package:mobile_recruitment_test/ui/typography/text.dart';
import 'package:mobile_recruitment_test/utils/translations.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<CalendarCubit, CalendarState>(
    builder:
        (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with buttons to navigate between months
            Row(
              children: [
                LodgifyIconButton(
                  iconData: Icons.chevron_left,
                  onPressed: () => context.read<CalendarCubit>().onPreviousMonthTapped(),
                ),
                const Spacer(),
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
                const Spacer(),
                LodgifyIconButton(
                  iconData: Icons.chevron_right,
                  onPressed: () => context.read<CalendarCubit>().onNextMonthTapped(),
                ),
              ],
            ),
            const Gap(16),
            // Weekdays header
            Row(
              mainAxisSize: MainAxisSize.min,
              children:
                  Translations.weekDaysEn
                      .map((weekday) => Expanded(child: Center(child: LText(text: weekday, type: LTextType.medium))))
                      .toList(),
            ),
            const Gap(8),
            // Calendar days
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
                  color: calendarDay.belongsToSelectedMonth ? LColors.shade1 : Colors.white,
                  child: Center(
                    child: LText(
                      text: '${calendarDay.date.day}',
                      type: LTextType.small,
                      fontWeight: calendarDay.isToday ? FontWeight.bold : null,
                      color: calendarDay.isToday ? LColors.danger : null,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
  );
}
