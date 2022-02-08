import 'package:bms_project/widgets/auth_page/login_inner.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static const route = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //print("login screen, w: $width, h: $height.");
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            width: width,
            height: height,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.fromLTRB(
                width * 0.2, height * 0.05, width * 0.2, height * 0.05),
            child: Column(
              children: [
                Card(
                  elevation: 15,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(width * 0.01),
                    child: const LoginInner(),
                    color: Colors.white,
                    height: height * 0.78, // 70% of the total height
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                const Center(
                  child: FittedBox(
                    child: Text(
                      "©2022 BloodDonors\nCreated by Hasan Masum and Ashfaq Rahman ",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
