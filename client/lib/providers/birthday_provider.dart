import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final birthdayProvider = StateNotifierProvider<BirthdayNotifier, Birthday>(
    (ref) => BirthdayNotifier());

class BirthdayNotifier extends StateNotifier<Birthday> {
  BirthdayNotifier() : super(Birthday(year: 2000, month: 1, day: 1));

  void updateYear(int year) {
    state = state.copyWith(year: year);
  }

  void updateMonth(int month) {
    state = state.copyWith(month: month);
  }

  void updateDay(int day) {
    state = state.copyWith(day: day);
  }

  Future<void> saveBirthdayToFirestore(String userId) async {
    final birthdayString = '${state.year}-${state.month}-${state.day}';
    final userDocument =
        FirebaseFirestore.instance.collection('users').doc(userId);

    await userDocument.update({'birthday': birthdayString});
  }
}

class Birthday {
  final int year;
  final int month;
  final int day;

  Birthday({required this.year, required this.month, required this.day});

  Birthday copyWith({int? year, int? month, int? day}) {
    return Birthday(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
    );
  }
}
