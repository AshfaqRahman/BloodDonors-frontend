// import 'dart:ffi';

import 'package:bms_project/modals/user.dart';
import 'package:bms_project/providers/users.dart';
import 'package:bms_project/widgets/location_map.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:geocode/geocode.dart';
// import 'package:mapbox_geocoding/model/reverse_geocoding.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:geocoding/geocoding.dart';

class SignUpPage extends StatefulWidget {
  VoidCallback switching;

  SignUpPage(this.switching, {Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

enum Gender { male, female, others }

class _SignUpPageState extends State<SignUpPage> {
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
    'B+',
    'AB+',
    'O+',
    'A-',
    'B-',
    'AB-',
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
    'location': <String, String>{
      'latitude': '',
      'longitude': '',
    },
    'password': '',
  };

  bool _foundLocation = false;

  var _userLocation;

  void _openingPlacePicker(BuildContext ctx) async {
    final result = await Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => LocationMap(),
      ),
    );
    try {
      Dio dio = Dio(); //initilize dio package
      String apiurl =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${result.latitude},${result.longitude}&key=$apikey";

      Response response = await dio.get(apiurl);
      // final x = await geoCode
      //     .reverseGeocoding(latitude: 23.726, longitude: 90.4251)
      //     .catchError((onError) {
      //   print(onError);
      // });
      print(response);
    } catch (e) {
      print(e);
    }

    _userLocation = result;

    setState(() {
      _foundLocation = true;
    });
    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(result.latitude, result.longitude);
    // print(placemarks);
  }

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
    if (_userLocation != null) {
      _initValues['location']['latitude'] = _userLocation.latitude.toString();
      _initValues['location']['longitude'] = _userLocation.longitude.toString();
    } else {
      showAlertDialog(ctx, "Location Error", "please select your location");
      return;
    }

    _initValues['blood group'] = _selectedBloodGroup;
    final is_valid =
        _form.currentState != null ? _form.currentState?.validate() : false;
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
        location: _initValues['location'],
        password: _initValues['password'],
        bloodGroup: _initValues['blood group']);
    // print("printing");
    // print(x.toString());
    Provider.of<Users>(context, listen: false).signUpUser(x).then((value) {
      if (value[0] == true) {
        showAlertDialog(context, "signed up", "you registered successfully!",
                flag: true)
            .then((_) {
          // print("here");
          // widget.switching();
        });
      } else if (value[0] == false) {
        showAlertDialog(context, "not signed up", value[1]);
      }
    }).catchError((_) {
      showAlertDialog(context, "server problem", "you got a problem!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          width: 400,
          child: ListView(
            shrinkWrap: true,
            children: [
              Form(
                key: _form,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      // initialValue: _initValues['name'],
                      decoration: const InputDecoration(labelText: 'Name'),
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
                        // _editedProduct = Product(
                        //     title: value,
                        //     price: _editedProduct.price,
                        //     description: _editedProduct.description,
                        //     imageUrl: _editedProduct.imageUrl,
                        //     id: _editedProduct.id,
                        //     isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      // initialValue: "ashfaq",
                      decoration: const InputDecoration(labelText: 'Email'),
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
                    TextFormField(
                      // initialValue: "ashfaq",
                      decoration: const InputDecoration(labelText: 'Phone'),
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
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          width: double.infinity,
                          child: Text('Gender'),
                        ),
                        RadioListTile(
                          title: const Text('Male'),
                          value: Gender.male.name,
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('Female'),
                          value: Gender.female.name,
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('Others'),
                          value: Gender.others.name,
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              // print(value.name);
                              _selectedGender = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Blood Group: "),
                        DropdownButton(
                          value: _selectedBloodGroup,
                          items: _bloodGroups.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedBloodGroup = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _openingPlacePicker(context),
                      child: Text('select your location'),
                    ),
                    if (_foundLocation)
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                            "your address: ${_userLocation.latitude}, ${_userLocation.longitude}"),
                      ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
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
                        ),
                      ),
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
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
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
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
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
                          return "password mismatch";
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => _saveForm(context),
                child: const SelectableText("sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
