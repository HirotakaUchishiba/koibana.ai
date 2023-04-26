import 'package:client/providers/user_email_provider.dart';
import 'package:client/providers/user_id_provider.dart';
import 'package:client/providers/user_password_provider.dart';
import 'package:client/screens/matching_screen/matching_sreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    String email = '';
    String password = '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'ログイン',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'メールアドレス',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                            width: 2,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => email = value,
                      validator: (value) =>
                          !EmailValidator.validate(value ?? '')
                              ? '有効なメールアドレスを入力してください'
                              : null,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'パスワード',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                            width: 2,
                          ),
                        ),
                      ),
                      obscureText: true,
                      onChanged: (value) => password = value,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'パスワードを入力してください'
                          : null,
                    ),
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
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              // Firebase Authenticationでログイン
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);

                              // プロバイダーにメールアドレスとパスワードをセット
                              ref.read(emailProvider.notifier).state = email;
                              ref.read(passwordProvider.notifier).state =
                                  password;
                              // プロバイダーにユーザーIDをセット
                              final uid = ref
                                  .read(userIdProvider.notifier)
                                  .state = userCredential.user!.uid;
                              print("セットされたuid:$uid");

                              // ログインに成功したら、適切な画面に遷移させる
                              // この例では、ホーム画面へ遷移します
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MatchingScreen()),
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'wrong-password') {
                                // パスワードが違います
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('パスワードが間違っています。'),
                                  ),
                                );
                              } else if (e.code == 'user-not-found') {
                                // ユーザーが見つかりません
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ユーザーが見つかりませんでした。'),
                                  ),
                                );
                              } else {
                                // その他のエラー
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.message ?? 'エラーが発生しました。'),
                                  ),
                                );
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: const Text('ログイン'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
