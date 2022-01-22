import 'package:flutter/material.dart';

class LoginLeft extends StatelessWidget {
  const LoginLeft({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: 250,
                width: 250,
                child: Image.asset(
                  "assets/images/pngfind.com-donate-png-726941.png",
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SelectableText(
                    "Blood Donors",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.redAccent.shade400,
                      fontSize: Theme.of(context).textTheme.headline3?.fontSize,
                    ),
                  ),
                  SelectableText(
                    "helps you to connect with blood donors and people who need blood",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Theme.of(context).textTheme.headline6?.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
