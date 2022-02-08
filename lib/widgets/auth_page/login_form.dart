import 'package:bms_project/modals/user.dart';
import 'package:bms_project/providers/users.dart';
import 'package:bms_project/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../common/margin.dart';

class LoginForm extends StatefulWidget {
  VoidCallback switching;

  LoginForm(this.switching, {Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode _passwordFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  String? _password; // String

  String? _email; // String

  Future<void> showAlertDialog(
      BuildContext context, String alertTitle, String alertContent,
      {bool flag = false}) async {
    // Create button
    Widget okButton = ElevatedButton(
      child: Text(
        "OK",
      ),
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

            Navigator.of(context).pushNamed(HomeScreen.route);
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
    Navigator.of(context).pushNamed(HomeScreen.route);
    return; // for testin

    final is_valid =
        _form.currentState != null ? _form.currentState!.validate() : false;
    if (is_valid == false) {
      return;
    }
    _form.currentState?.save();
    if (_email == null || _password == null) return;
    Map<String, String> m = {
      'email': _email!,
      'password': _password!,
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double w = width * 0.3;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        EmailPasswordInputWidget(context, _form, onEmailSaved: (email) {
          _email = email;
        }, onPasswordSaved: (password) {
          _password = password;
        }),
        VerticalSpacing(height * 0.02),
        SizedBox(
          width: w,
          height: height * 0.04,
          child: ElevatedButton(
            onPressed: _saveForm,
            // onPressed: () =>
            // Navigator.of(context).pushNamed(HomePage.route),
            child: const Text("Log in"),
          ),
        ),
        VerticalSpacing(height * 0.02),
        AreYouRegistered(widget: widget),
      ],
    );
  }
}

class AreYouRegistered extends StatelessWidget {
  const AreYouRegistered({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final LoginForm widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SelectableText('Not registered yet? '),
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
              'Sign up',
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

class EmailPasswordInputWidget extends StatefulWidget {
  EmailPasswordInputWidget(
    this.context,
    this._form, {
    Key? key,
    required this.onEmailSaved,
    required this.onPasswordSaved,
  }) : super(key: key);

  final BuildContext context;
  var _form;
  final Function onEmailSaved;
  final Function onPasswordSaved;

  @override
  State<EmailPasswordInputWidget> createState() =>
      _EmailPasswordInputWidgetState();
}

class _EmailPasswordInputWidgetState extends State<EmailPasswordInputWidget> {
  final FocusNode _passwordFocusNode = FocusNode();
  var _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double w = width * 0.3;
    return Container(
      //color: Colors.blueGrey,
      width: w,
      child: Form(
        key: widget._form,
        child: Column(
          children: <Widget>[
            TextFormField(
              //initialValue: "Email",
              cursorColor: Theme.of(context).primaryColor,
              decoration: _getInputDecoration('Email', null),
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
                widget.onEmailSaved(value);
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            TextFormField(
              cursorColor: Theme.of(context).primaryColor,
              decoration: _getInputDecoration(
                'Password',
                IconButton(
                  // Based on passwordVisible state choose the icon
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColor,
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
                widget.onPasswordSaved(value);
              },
            ),
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
        color: Theme.of(widget.context).primaryColor,
        fontSize: Theme.of(widget.context).textTheme.subtitle2?.fontSize,
      ),
      //errorText: 'Please insert a valid email',
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(widget.context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(widget.context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      suffixIcon: icon,
    );
  }
}
