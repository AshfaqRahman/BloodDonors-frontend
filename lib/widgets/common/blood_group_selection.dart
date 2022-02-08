import 'dart:ui';

import 'package:flutter/material.dart';

class BloodGroupDropdown extends StatefulWidget {
  String? selectedBloodGroup;
  Function onBGSelected;
  BloodGroupDropdown({
    Key? key,
    required this.selectedBloodGroup,
    required this.onBGSelected,
  }) : super(key: key);

  @override
  _BloodGroupDropdownState createState() => _BloodGroupDropdownState();
}

class _BloodGroupDropdownState extends State<BloodGroupDropdown> {
  final List<String> _bloodGroups = const [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // customize dropdwon design
  // https://www.youtube.com/watch?v=-6GBAGj-h4Q
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Theme.of(context).primaryColorLight,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            hint: const Text("Choose Blood Group"),
            value: widget.selectedBloodGroup,
            items: _bloodGroups.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                widget.selectedBloodGroup = newValue!;
                widget.onBGSelected(newValue);
              });
            },
          ),
        ),
      ),
    );
  }
}
