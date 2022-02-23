import 'package:bms_project/providers/donation_provider.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/widgets/common/dialog_topbar_widget.dart';
import 'package:bms_project/widgets/common/location_input.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  static String TAG = "AddDonationDialog";

  OsmLocation? selectedLocation;
  String? selectedDate;

  /**
   * send donation to backend
   */
  void _saveDonation() async {
    if (selectedLocation == null) {
      Log.d(TAG, "_saveLocation(): location not selected!");
      return;
    }

    if (selectedDate == null) {
      Log.d(TAG, "_saveLocation(): date not selected!");
      return;
    }

    ProviderResponse response = await Provider.of<DonationProvider>(context, listen: false)
        .addDonation(selectedLocation!, selectedDate!);

    Navigator.of(context).pop(response);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        width: width * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogTopBar(title: "Add donation"),
            const Divider(
              height: 10,
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            InputLocation(
              onLocationSelected: (OsmLocation location) {
                Log.d(TAG, "selected location: ${location.displayName}");
                selectedLocation = location;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            DateInput(
              onDateSelected: (date) {
                Log.d(TAG, "selected date: $date");
                selectedDate = date;
              },
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              height: height * 0.05,
              child: ElevatedButton(
                onPressed: () {
                  _saveDonation();
                },
                child: const Text("ADD"),
              ),
            ),
          ],
        ));
  }
}

class DateInput extends StatefulWidget {
  final Function onDateSelected;
  const DateInput({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  static const String TAG = "DateInput";

  late String dateString;

  TextEditingController dateTextController = TextEditingController();

  @override
  void initState() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    dateString = dateFormat.format(DateTime.now());
    //print(dateString);
    super.initState();
  }

  @override
  void openDatePickerDialog() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(DateTime.now().year - 3, 1),
      lastDate: DateTime.now(),
      helpText: 'Select a date',
    );

    setState(() {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      dateString = dateFormat.format(newDate!);
      Log.d(TAG, "selected date: $dateString");
      dateTextController.text = dateString;
      widget.onDateSelected(dateString);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return MyTextField(
      hint: "Donation Date",
      onSubmitText: (value) {},
      onTap: openDatePickerDialog,
      textController: dateTextController,
      suffixIcon: const Icon(
        Icons.calendar_today,
        color: Colors.white,
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  static const String TAG = "MyTextField";
  MyTextField({
    Key? key,
    required this.hint,
    required this.onSubmitText,
    required this.suffixIcon,
    required this.textController,
    this.onTap,
  }) : super(key: key);

  TextEditingController textController;
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
      controller: textController,
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
                Log.d(TAG, "$hint: tapped");
                if (onTap != null) onTap!();
              },
              icon: suffixIcon,
            ),
          ),
        ),
      ),
    );
  }
}
