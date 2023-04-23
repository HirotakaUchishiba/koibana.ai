import 'package:client/providers/user_sex_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterSexScreen extends StatelessWidget {
  const RegisterSexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('性別選択',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background_image2.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Consumer(
            builder: (context, ref, child) {
              final userSex = ref.watch(userSexProvider);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: const Text('女性'),
                    leading: Radio<String>(
                      value: 'Female',
                      groupValue: userSex,
                      onChanged: (value) =>
                          ref.read(userSexProvider.notifier).state = value!,
                    ),
                  ),
                  ListTile(
                    title: const Text('男性'),
                    leading: Radio<String>(
                      value: 'Male',
                      groupValue: userSex,
                      onChanged: (value) =>
                          ref.read(userSexProvider.notifier).state = value!,
                    ),
                  ),
                  ListTile(
                    title: const Text('その他'),
                    leading: Radio<String>(
                      value: 'Other',
                      groupValue: userSex,
                      onChanged: (value) =>
                          ref.read(userSexProvider.notifier).state = value!,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('ここで性別を設定するよ。',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 16),
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
                      onPressed: userSex != "" ? () {} : null,
                      child: const Text('次へ'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
