import 'package:flutter/material.dart';
import 'package:mobile_recruitment_test/calendar_screen/calendar_screen.dart';
import 'package:mobile_recruitment_test/ui/colors.dart';
import 'package:mobile_recruitment_test/utils/translations.dart';

class RecruitmentApp extends StatelessWidget {
  const RecruitmentApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: Translations.appTitle,
    theme: ThemeData(scaffoldBackgroundColor: LColors.background),
    debugShowCheckedModeBanner: false,
    home: const MonthCalendar(),
  );
}
