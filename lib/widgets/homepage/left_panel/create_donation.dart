import 'package:bms_project/widgets/common/dialog_topbar_widget.dart';
import 'package:bms_project/widgets/common/location_input.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../modals/osm_model.dart';
import '../../../utils/debug.dart';
import '../../../utils/location.dart';
import '../../map/osm_map.dart';

class AddDonationDialog extends StatefulWidget {
  const AddDonationDialog({Key? key}) : super(key: key);

  @override
  _AddDonationDialogState createState() => _AddDonationDialogState();
}

class _AddDonationDialogState extends State<AddDonationDialog> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        width: width * 0.3,
        child: Column(
          children: [
            const DialogTopBar(title: "Add donation"),
            const Divider(
              height: 10,
              thickness: 1,
            ),
            InputLocation(
              onLocationSelected: (location) {},
            ),
          ],
        ));
  }
}

class MyTextField extends StatelessWidget {
  static const String TAG = "MyTextField";
  MyTextField({
    Key? key,
    required this.hint,
    required this.onSubmitText,
    required this.suffixIcon,
    this.onTap,
  }) : super(key: key);

  TextEditingController msgController = TextEditingController();
  final String hint;
  final Function onSubmitText;
  final Function? onTap;
  final Icon suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () {
        Log.d(TAG, "$hint: tapped");
        if (onTap != null) onTap!();
      },
      style: Theme.of(context).textTheme.subtitle1,
      cursorColor: Theme.of(context).primaryColor,
      controller: msgController,
      onSubmitted: (value) {
        Log.d(TAG, value);
        if (value != "") {
          onSubmitText(value);
          msgController.text = "";
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
        suffixIcon: Padding(
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
                  msgController.text = "";
                }
              },
              icon: suffixIcon,
            ),
          ),
        ),
      ),
    );
  }
}
