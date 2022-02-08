

import 'package:flutter/material.dart';

class VerticalSpacing extends StatelessWidget {
  const VerticalSpacing(this.height,{
    Key? key,
    
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing(this.width,{
    Key? key,
    
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}