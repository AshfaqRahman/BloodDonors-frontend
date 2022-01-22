import 'package:bms_project/widgets/login_page/login_left.dart';
import 'package:bms_project/widgets/login_page/login_right.dart';
import 'package:bms_project/widgets/login_page/sign_up_page.dart';
import 'package:flutter/material.dart';

class LoginInner extends StatefulWidget {
  const LoginInner({Key? key}) : super(key: key);

  @override
  State<LoginInner> createState() => _LoginInnerState();
}

class _LoginInnerState extends State<LoginInner> {
  bool loginPage = true;

  void switchToSignUpPage() {
    setState(() {
      loginPage = false;
    });
  }

  void switchToLoginPage() {
    setState(() {
      loginPage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const LoginLeft(),
        loginPage
            ? LoginRight(switchToSignUpPage)
            : SignUpPage(switchToLoginPage),
      ],
    );
  }
}
