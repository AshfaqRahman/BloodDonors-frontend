// import 'dart:ffi';

import 'package:bms_project/modals/location.dart';
import 'package:bms_project/modals/user.dart';
import 'package:bms_project/providers/users.dart';
import 'package:bms_project/widgets/common/blood_group_selection.dart';
import 'package:bms_project/widgets/common/location_input.dart';
import 'package:bms_project/widgets/location_map.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:geocode/geocode.dart';
// import 'package:mapbox_geocoding/model/reverse_geocoding.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../modals/osm_model.dart';
import '../../utils/location.dart';
import '../common/margin.dart';
import '../map/osm_map.dart';
// import 'package:geocoding/geocoding.dart';

class SignUpForm extends StatefulWidget {
  VoidCallback switching;

  SignUpForm(this.switching, {Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

enum Gender { male, female, others }

class _SignUpFormState extends State<SignUpForm> {
  final _form = GlobalKey<FormState>();
  var apikey = 'AIzaSyA0KyAjNU8ES2Bx3yqbIiXXHuXDyTy9aBM';

  late String _selectedBloodGroup = 'A+';
  late String _password;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  final TextEditingController _passwordController = TextEditingController();

  // List of items in our dropdown menu
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

  var _selectedGender;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  final Map<String, dynamic> _initValues = {
    'name': '',
    'email': '',
    'phone': '',
    'gender': '',
    'blood group': '',
    'location': <String, dynamic>{
      'latitude': 0.0,
      'longitude': 0.0,
      'description': '',
    },
    'password': '',
  };

  bool _foundLocation = false;

  var _userLatLng;
  var _userLocationText;

  Future<void> showAlertDialog(
      BuildContext context, String alertTitle, String alertContent,
      {bool flag = false}) async {
    // Create button
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        if (flag) {
          widget.switching();
        }
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: Text(alertContent),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _saveForm(BuildContext ctx) async {
    if (_selectedGender != null)
      _initValues['gender'] = _selectedGender.toString();
    else {
      showAlertDialog(ctx, "Gender Error", "Gender is not selected");
      return;
    }
    if (_userLatLng != null) {
      _initValues['location']['latitude'] = _userLatLng.latitude;
      _initValues['location']['longitude'] = _userLatLng.longitude;
      if (_userLocationText != null) {
        _initValues['location']['display_name'] = _userLocationText;
      } else {
        _initValues['location']['display_name'] =
            "Unkown(${_userLatLng.latitude}, ${_userLatLng.longitude})";
      }
    } else {
      showAlertDialog(ctx, "Location Error", "please select your location");
      return;
    }

    _initValues['blood group'] = _selectedBloodGroup;
    final is_valid =
        _form.currentState != null ? _form.currentState!.validate() : false;
    if (is_valid == false) {
      return;
    }
    _form.currentState?.save();
    _initValues['password'] = _password;
    // print(_initValues);
    User x = User(
        name: _initValues['name'],
        email: _initValues['email'],
        phone: _initValues['phone'],
        gender: _initValues['gender'],
        location: Location.fromMap(_initValues['location']),
        password: _initValues['password'],
        bloodGroup: _initValues['blood group']);
    // print("printing user input.");
    // print(x.toMap());
    Provider.of<Users>(context, listen: false).signUpUser(x).then((value) {
      if (value['success'] == true) {
        showAlertDialog(context, "signed up", "you registered successfully!",
                flag: true)
            .then((_) {
          // print("here");
          // widget.switching();
        });
      } else if (value['success'] == false) {
        showAlertDialog(context, "not signed up", value["message"]);
      }
    }).catchError((_) {
      showAlertDialog(context, "server problem", "you got a problem!");
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double w = width * 0.3;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _form,
              child: Column(
                //shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    // initialValue: _initValues['name'],
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: _getInputDecoration('Name', null),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Z a-z]')),
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _initValues['name'] = value!;
                    },
                  ),
                  VerticalSpacing(height * 0.01),
                  TextFormField(
                    // initialValue: "ashfaq",
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: _getInputDecoration('Email', null),
                    textInputAction: TextInputAction.next,
                    focusNode: _emailFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_phoneFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide an email.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _initValues['email'] = value!;
                    },
                  ),
                  VerticalSpacing(height * 0.01),
                  TextFormField(
                    // initialValue: "ashfaq",
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: _getInputDecoration('Phone', null),
                    textInputAction: TextInputAction.next,
                    focusNode: _phoneFocusNode,
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
                      _initValues['phone'] = value!;
                    },
                  ),
                  VerticalSpacing(height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Gender:'),
                      Radio(
                          value: Gender.male.name,
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          }),
                      Text("Male"),
                      Radio(
                        value: Gender.female.name,
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                      const Text('Female'),
                      Radio(
                        value: Gender.others.name,
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            // print(value.name);
                            _selectedGender = value;
                          });
                        },
                      ),
                      const Text('Others')
                    ],
                  ),
                  BloodGroupDropdown(
                    selectedBloodGroup: _selectedBloodGroup,
                    onBGSelected: (String? newValue) {
                      setState(() {
                        _selectedBloodGroup = newValue!;
                      });
                    },
                  ),
                  InputLocation(
                    onLocationSelected: (selectedLocation) {
                      _userLatLng = LatLng(selectedLocation.latitude,
                          selectedLocation.longitude);
                      _userLocationText = selectedLocation.displayName;
                    },
                  ),
                  VerticalSpacing(height * 0.01),
                  TextFormField(
                    controller: _passwordController,
                    decoration: _getInputDecoration(
                        "Password",
                        IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )),
                    obscureText: !_passwordVisible,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      if (value!.length < 8) {
                        return "your password must be >= 8 characters";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      this._password = value!;
                    },
                  ),
                  VerticalSpacing(height * 0.01),
                  TextFormField(
                    decoration: _getInputDecoration(
                      'Confirm Password',
                      IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_confirmPasswordVisible,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      // print(value);
                      // print(_passwordController.text);
                      if (value != _passwordController.text) {
                        return "Password mismatch";
                      }
                      return null;
                    },
                    onSaved: (value) {},
                  ),
                ],
              ),
            ),
            VerticalSpacing(height * 0.01),
            SizedBox(
              width: w,
              height: height * 0.04,
              child: ElevatedButton(
                onPressed: () => _saveForm(context),
                child: const Text("Sign up"),
              ),
            ),
            VerticalSpacing(height * 0.02),
            AlreadyHaveAccount(widget: widget),
          ],
        ),
      ),
    );
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
}

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final SignUpForm widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SelectableText('Areadly have account? '),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          // onEnter: (_) {
          //   widget.switching();
          // },
          child: GestureDetector(
            onTap: () {
              widget.switching();
            },
            child: Text(
              'Log in',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        const SelectableText(' here'),
      ],
    );
  }
}
