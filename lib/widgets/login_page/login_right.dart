import 'package:bms_project/modals/user.dart';
import 'package:bms_project/providers/users.dart';
import 'package:bms_project/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginRight extends StatefulWidget {
  VoidCallback switching;

  LoginRight(this.switching, {Key? key}) : super(key: key);

  @override
  State<LoginRight> createState() => _LoginRightState();
}

class _LoginRightState extends State<LoginRight> {
  final FocusNode _passwordFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var _passwordVisible = false;

  late String _password;

  late String _email;

  Future<void> showAlertDialog(
      BuildContext context, String alertTitle, String alertContent,
      {bool flag = false}) async {
    // Create button
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        if (flag) {
          Provider.of<Users>(context, listen: false)
              .getUserData()
              .then((value) {
            // print(value);
            // print(value.runtimeType);
            // print(value[0].runtimeType);
            // print(value[1].runtimeType);
            // print(value[1]['LONGITUDE'].runtimeType);

            Navigator.of(context).pushNamed(HomePage.route);
          });
        }
        Navigator.of(context).pop();
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

  Future<void> _saveForm() async {
    final is_valid =
        _form.currentState != null ? _form.currentState!.validate() : false;
    if (is_valid == false) {
      return;
    }
    _form.currentState?.save();
    Map<String, String> m = {
      'email': _email,
      'password': _password,
    };
    Provider.of<Users>(context, listen: false).signInUser(m).then((value) {
      if (value[0] == true) {
        showAlertDialog(context, "signed in", value[1], flag: true);
      } else if (value[0] == false) {
        showAlertDialog(context, "not logged in", value[1]);
      }
    }).catchError((_) {
      showAlertDialog(context, "server problem", "you got a problem!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
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
                      decoration: const InputDecoration(labelText: 'Email'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide an email.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    TextFormField(
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
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _saveForm,
                child: const SelectableText("Login"),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  const SelectableText('not registered yet? '),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    // onEnter: (_) {
                    //   widget.switching();
                    // },
                    child: GestureDetector(
                      onTap: () {
                        widget.switching();
                      },
                      child: const Text(
                        'sign up',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SelectableText(' here'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
