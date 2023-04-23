import 'package:flutter_riverpod/flutter_riverpod.dart';

class Birthday extends StateNotifier<DateTime> {
  Birthday() : super(DateTime.now());

  void updateYear(int year) {
    state = DateTime(year, state.month, state.day);
  }

  void updateMonth(int month) {
    state = DateTime(state.year, month, state.day);
  }

  void updateDay(int day) {
    state = DateTime(state.year, state.month, day);
  }
}

final birthdayProvider = StateNotifierProvider<Birthday, DateTime>((ref) => Birthday());
