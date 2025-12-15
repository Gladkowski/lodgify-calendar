import 'package:flutter/material.dart';
import 'package:mobile_recruitment_test/colors.dart';
import 'package:mobile_recruitment_test/month_calendar/month_calendar.dart';
import 'package:mobile_recruitment_test/translations.dart';


class RecruitmentApp extends StatelessWidget {
  const RecruitmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Translations.appTitle,
      theme: ThemeData(scaffoldBackgroundColor: LColors.background),
      debugShowCheckedModeBanner: false,
      home: const MonthCalendar(),
    );
  }
}