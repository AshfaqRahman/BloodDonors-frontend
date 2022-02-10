import 'package:flutter/material.dart';
InputDecoration getInputDecoration(
    BuildContext context, String labelText, IconButton? icon, double? cornerRadius) {
  return InputDecoration(
    labelText: labelText,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    labelStyle: TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: Theme.of(context).textTheme.subtitle2?.fontSize,
    ),
    //errorText: 'Please insert a valid email',
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.circular(cornerRadius??5),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.circular(cornerRadius??5),
    ),
    suffixIcon: icon,
  );
}
