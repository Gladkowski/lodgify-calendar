import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'month_calendar_cubit.freezed.dart';
part 'month_calendar_state.dart';

class MonthCalendarCubit extends Cubit<MonthCalendarState> {
  MonthCalendarCubit() : super(MonthCalendarState(testData: 0));

  void init() {}

  Future<void> addTestData({required double amount}) async {
    emit(state.copyWith(testData: amount));
  }
}
