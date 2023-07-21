import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tennis/app.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tennis/app.dart';

// ログイン画面用Widget
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("スタート画面",
            style: TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
        backgroundColor: const Color.fromARGB(173, 49, 44, 44),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // メールアドレス入力
              Focus(
                focusNode: _emailFocus,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Mail address'),
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  },
                  onFieldSubmitted: (_) {
                    // フォーカスを外してキーボードを隠す
                    _emailFocus.unfocus();
                    // 次のフィールドにフォーカスを移す
                    FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                ),
              ),
              // パスワード入力
              Focus(
                focusNode: _passwordFocus,
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Password (at least 6 characters)'),
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      password = value;
                    });
                  },
                  onFieldSubmitted: (_) {
                    // フォーカスを外してキーボードを隠す
                    _passwordFocus.unfocus();
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                // ユーザー登録ボタン
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(173, 49, 44, 44),
                  ),
                  child: const Text('Sign Up',
                      style:
                          TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final inf = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ユーザー登録に成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return AppPage();
                        }),
                      );
                    } catch (e) {
                      // ユーザー登録に失敗した場合
                      setState(() {
                        infoText = "Registration failed:${e.toString()}";
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                // ログイン登録ボタン
                child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(173, 49, 44, 44),
                  ),
                  child: const Text('Sign in',
                      style:
                          TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final inf = await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ログインに成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return AppPage();
                        }),
                      );
                    } catch (e) {
                      // ログインに失敗した場合
                      setState(() {
                        infoText = "ログインに失敗しました：${e.toString()}";
                      });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
