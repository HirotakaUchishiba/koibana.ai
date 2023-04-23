import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final nameProvider = StateProvider<String>((ref) => '');

class RegisterNameScreen extends HookConsumerWidget {
  const RegisterNameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(nameProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('名前',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background_image2.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (value) {
                    ref.read(nameProvider);
                  },
                  decoration: const InputDecoration(
                    labelText: '名前',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text('ここで決めた名前がプロフィールに表示されるよ。',
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
                      // Save name to Firebase and navigate to next screen
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
}
