import 'package:bms_project/widgets/login_page/login_inner.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          color: Colors.redAccent,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.1, horizontal: height * 0.1),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: LoginInner(),
                color: Colors.white,
                height: height * 0.8,
                width: width * 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
