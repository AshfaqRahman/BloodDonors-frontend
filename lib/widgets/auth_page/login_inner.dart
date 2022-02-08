import 'package:bms_project/widgets/auth_page/login_form.dart';
import 'package:flutter/material.dart';

import 'login_left.dart';
import 'sign_up_form.dart';

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
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(

            // color: Colors.green,
            width: MediaQuery.of(context).size.width * 0.285,
            child: const LoginLeft()),
        Container(
          //color: Colors.amber,
          width: MediaQuery.of(context).size.width * 0.285,
          child: loginPage
              ?
              LoginForm(switchToSignUpPage)
          : SignUpForm(switchToLoginPage)
          ,
        ),
      ],
    );
  }
}
