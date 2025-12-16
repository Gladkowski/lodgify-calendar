import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_recruitment_test/calendar_screen/bloc/calendar_cubit.dart';
import 'package:mobile_recruitment_test/calendar_screen/widgets/calendar_widget.dart';

/// Main calendar screen that displays a monthly calendar view.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => CalendarCubit()..init(), child: const _Content());
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) => BlocBuilder<CalendarCubit, CalendarState>(
    builder:
        (context, state) => Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(padding: const EdgeInsets.all(8), child: const CalendarWidget()),
            ),
          ),
        ),
  );
}
