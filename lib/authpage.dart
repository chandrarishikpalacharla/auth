import 'package:flutter/material.dart';
import 'package:photo/signin.dart';
import 'package:photo/signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) =>
  isLogin? SignIN(onClickedSignUp: toggle,) : SignUp(onClickedSignIn: toggle);
  void toggle() =>setState(() {
    isLogin = !isLogin;
  });
}