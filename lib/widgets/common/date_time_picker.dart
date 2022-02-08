import 'package:bms_project/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// https://enappd.com/blog/building-a-flutter-datetime-picker/55/
class DateTimePicker extends StatefulWidget {
  final Function timeCallback;
  final Function dateCallback;
  const DateTimePicker(
      {required this.dateCallback, required this.timeCallback, Key? key})
      : super(key: key);

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  final TAG = "DateTimePicker";

  InputDecoration _getInputDecoration(String labelText, IconButton? icon) {
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
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      suffixIcon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print("$TAG: w ${width}");
    return SizedBox(
      width: width * 0.3,
      child: Row(
        children: [
          Flexible(flex: 1, child: DateInput(widget.dateCallback)),
          HorizontalSpacing(10),
          Flexible(flex: 1, child: TimeInput(widget.timeCallback)),
        ],
      ),
    );
  }
}

class TimeInput extends StatefulWidget {
  final Function timeCallback;
  const TimeInput(this.timeCallback, {Key? key}) : super(key: key);

  @override
  _TimeInputState createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  // String time = DateTime.now().;

  late String timeString;

  @override
  void initState() {
    // TODO: implement initState
    //var format = DateFormat.jm();
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    timeString = "${DateTime.now().hour}:${DateTime.now().minute}";
    // widget.timeCallback(timeString);
    // print(timeString);
    super.initState();
  }

  void openTimePickerDialog() async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    );
    // print("${newTime!.hour} ${newTime.minute}");

    setState(() {
      timeString = "${newTime!.hour}:${newTime.minute}";
      widget.timeCallback(timeString);
      print(timeString);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 4.0,
      onPressed: openTimePickerDialog,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                        size: 18.0,
                        color: themeData.primaryColor,
                      ),
                      Text(
                        " $timeString",
                        style: TextStyle(
                          color: themeData.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
              "  Change",
              style: TextStyle(
                color: themeData.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      color: Colors.white,
    );
  }
}

class DateInput extends StatefulWidget {
  final Function dateCallback;
  const DateInput(this.dateCallback, {Key? key}) : super(key: key);

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  late String dateString;

  @override
  void initState() {
    // TODO: implement initState
    //var format = DateFormat.jm();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    dateString = dateFormat.format(DateTime.now());
    print(dateString);
    // widget.dateCallback(dateString);
    super.initState();
  }

  @override
  void openDatePickerDialog() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2023, 7),
      helpText: 'Select a date',
    );

    setState(() {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      dateString = dateFormat.format(newDate!);
      widget.dateCallback(dateString);
      print(dateString);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 4.0,
      onPressed: openDatePickerDialog,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                        size: 18.0,
                        color: themeData.primaryColor,
                      ),
                      Text(
                        " $dateString",
                        style: TextStyle(
                          color: themeData.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
              "  Change",
              style: TextStyle(
                color: themeData.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      color: Colors.white,
    );
  }
}
