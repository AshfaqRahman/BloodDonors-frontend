import 'package:flutter/material.dart';

import '../../utils/debug.dart';

class MyTextField extends StatelessWidget {
  static const String TAG = "MyTextField";
  MyTextField({
    Key? key,
    required this.hint,
    required this.onSubmitText,
    this.suffixIcon,
    required this.vanishTextOnSubmit,
  }) : super(key: key);

  TextEditingController msgController = TextEditingController();
  final String hint;
  final Function onSubmitText;
  Icon? suffixIcon;
  final bool vanishTextOnSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(context).textTheme.subtitle1,
      cursorColor: Theme.of(context).primaryColor,
      controller: msgController,
      onSubmitted: (value) {
        Log.d(TAG, value);
        if (value != "") {
          onSubmitText(value);
          if (vanishTextOnSubmit) {
            msgController.text = "";
          }
        }
      },
      decoration: InputDecoration(
        labelText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: Theme.of(context).textTheme.subtitle2?.fontSize,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        suffixIcon: suffixIcon == null? null : Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
            ),
            child: IconButton(
              onPressed: () {
                String msg = msgController.text;
                if (msg != "") {
                  onSubmitText(msg);
                  if (vanishTextOnSubmit) {
                    msgController.text = "";
                  }
                }
              },
              icon: suffixIcon!,
            ),
          ),
        ),
      ),
    );
  }
}


