import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSex extends StateNotifier<String> {
  UserSex() : super('');

  void updateUserSex(String sex) {
    state = sex;
  }
}

final userSexProvider = StateNotifierProvider<UserSex, String>((ref) => UserSex());
