import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_cubit.freezed.dart';
part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarState(testData: 0));

  void init() {}

  Future<void> addTestData({required double amount}) async {
    emit(state.copyWith(testData: amount));
  }
}
