import 'package:flutter/material.dart';

class LoginLeft extends StatelessWidget {
  const LoginLeft({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //print("login left, w: $width, h: $height.");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/blood.png',
            height: width * 0.2,
            width: width * 0.2,
          ),
          SizedBox(
            height: height*0.02,
          ),
          FittedBox(
            child: Text(
              "Blood Donors",
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  color: Theme.of(context).primaryColor,
                  fontSize: Theme.of(context).textTheme.headline3?.fontSize,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            height:height*0.005,
            width: width*0.063,
          ),
          SizedBox(
            height: height*0.01,
          ),
          FittedBox(
            child: Text(
              "Helps you to connect with blood donors\nand people who need blood",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: Theme.of(context).textTheme.subtitle1?.fontSize,
              ),
            ),
          )
        ],
      ),
    );
  }
}
