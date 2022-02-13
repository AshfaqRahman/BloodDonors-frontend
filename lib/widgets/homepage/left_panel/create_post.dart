import 'dart:convert';
import 'dart:html';

import 'package:bms_project/modals/blood_post_model.dart';
import 'package:bms_project/providers/blood_post_provider.dart' as provide;
import 'package:bms_project/modals/location.dart';
import 'package:bms_project/modals/osm_model.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/widgets/common/blood_group_selection.dart';
import 'package:bms_project/widgets/common/date_time_picker.dart';
import 'package:bms_project/widgets/common/location_input.dart';
import 'package:bms_project/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _form = GlobalKey<FormState>();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  late String? _selectedBG;
  late int? _amount;
  late OsmLocation? _selectedLocation;
  late String? _contactNumber;
  late String? _dueDate = dateFormat.format(DateTime.now());
  late String? _dueTime = "${DateTime.now().hour}:${DateTime.now().minute}";
  late Map<String, dynamic> _additionalInfo = {};

  void _setDueDate(String newDate) {
    setState(() {
      _dueDate = newDate;
    });
  }

  void _setDueTime(String newTime) {
    setState(() {
      _dueTime = newTime;
    });
  }

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

  Future<void> _saveForm(BuildContext ctx) async {
    // if (_dueDate == null ||
    //     _dueTime == null ||
    //     _contactNumber == null ||
    //     _selectedBG == null ||
    //     _amount == null ||
    //     _selectedLocation == null) return;
    _form.currentState?.save();
    print(
        '${_dueDate ?? ""}, $_dueTime, $_amount, $_contactNumber, $_selectedBG, $_selectedLocation');
    BloodPostUserInput bloodPost = BloodPostUserInput(
      dueTime: '${_dueDate} ${_dueTime}:00',
      amount: _amount!,
      contact: _contactNumber!,
      bloodGroup: _selectedBG!,
      location: _selectedLocation!,
      additionalInfo: _additionalInfo,
    );

    print(json.encode(bloodPost.toMap()));
    Provider.of<provide.BloodPostProvider>(ctx, listen: false)
        .createPost(bloodPost)
        .then((ProviderResponse value) {
      Navigator.of(ctx).pop(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ThemeData themeData = Theme.of(context);
    double margin = 15.0;
    return Container(
      width: width * 0.3,
      //height: height * 0.7,
      child: Form(
        key: _form,
        child: ListView(
          shrinkWrap: true,
          children: [
            const TopBar(),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            VerticalSpacing(margin),
            BloodGroupDropdown(
              selectedBloodGroup: null,
              onBGSelected: (newBg) {
                _selectedBG = newBg;
              },
            ),
            VerticalSpacing(margin),
            TextFormField(
              cursorColor: Theme.of(context).primaryColor,
              decoration: _getInputDecoration('Amount(bag)', null),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name.';
                }
                return null;
              },
              onSaved: (value) {
                _amount = int.parse(value!);
                // _initValues['name'] = value!;
              },
            ),
            VerticalSpacing(margin),
            InputLocation(
              onLocationSelected: (OsmLocation? location) {
                _selectedLocation = location!;
                // print('found location: ${location?.displayName}');
              },
            ),
            VerticalSpacing(margin),
            DateTimePicker(
                dateCallback: _setDueDate, timeCallback: _setDueTime),
            VerticalSpacing(margin),
            TextFormField(
              cursorColor: Theme.of(context).primaryColor,
              decoration: _getInputDecoration('Phone', null),
              textInputAction: TextInputAction.next,
              focusNode: FocusNode(),
              onFieldSubmitted: (_) {
                // FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: (value) {
                String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                RegExp regExp = new RegExp(patttern);
                if (value!.length == 0) {
                  return 'Please enter mobile number';
                } else if (value.length > 12) {
                  return "phone number is too large";
                } else if (!regExp.hasMatch(value)) {
                  return 'Please enter valid mobile number';
                }
                return null;
              },
              onSaved: (value) {
                _contactNumber = value!;
                // _initValues['phone'] = value!;
              },
            ),
            VerticalSpacing(margin),
            TextFormField(
              maxLines: 3,
              decoration:
                  _getInputDecoration("Patient Information", null).copyWith(
                contentPadding: EdgeInsets.all(12),
              ),
              onSaved: (value) {
                _additionalInfo['text'] = value!;
              },
            ),
            VerticalSpacing(margin),
            SizedBox(
              //width: width,
              height: height * 0.05,
              child: ElevatedButton(
                onPressed: () {
                  _saveForm(context);
                },
                child: const Text("POST"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("         "),
          Text(
            "Create Post",
            style: themeData.textTheme.headline6
                ?.copyWith(color: themeData.primaryColor),
          ),
          //const Spacer(),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(FontAwesomeIcons.timesCircle))
        ],
      ),
    );
  }
}
