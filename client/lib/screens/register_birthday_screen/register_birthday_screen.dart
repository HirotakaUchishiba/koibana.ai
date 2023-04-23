import 'package:client/providers/birthday_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterBirthdayScreen extends HookConsumerWidget {
  const RegisterBirthdayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birthday = ref.watch(birthdayProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: const Text('誕生日',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background_image2.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextField(context, ref, '年', birthday.year,
                        (value) {
                      ref.read(birthdayProvider.notifier).updateYear(value);
                    }),
                    const SizedBox(width: 8),
                    _buildTextField(context, ref, '月', birthday.month,
                        (value) {
                      ref.read(birthdayProvider.notifier).updateMonth(value);
                    }),
                    const SizedBox(width: 8),
                    _buildTextField(context, ref, '日', birthday.day, (value) {
                      ref.read(birthdayProvider.notifier).updateDay(value);
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('ここで誕生日を設定するよ。',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.pinkAccent,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Save birthday to Firebase and navigate to next screen
                    },
                    child: const Text('次へ'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, WidgetRef ref, String label,
      int initialValue, Function(int) onChanged) {
    return SizedBox(
      width: 60,
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value.isNotEmpty) {
            onChanged(int.parse(value));
          }
        },
        inputFormatters: [
          // Allow only digits
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        controller: TextEditingController(text: initialValue.toString()),
      ),
    );
  }
}
