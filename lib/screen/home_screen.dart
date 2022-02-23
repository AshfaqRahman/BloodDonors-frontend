import 'dart:ui';

import 'package:bms_project/modals/user_model.dart';
import 'package:bms_project/providers/users_provider.dart';
import 'package:bms_project/utils/auth_util.dart';
import 'package:bms_project/utils/debug.dart';
import 'package:bms_project/widgets/homepage/left_panel.dart';
import 'package:bms_project/widgets/homepage/mid_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/js.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const TAG = "HomeScreen";
  late BuildContext ctx;
  var _isInit = true;
  var users;

  LeftPanelOption midPanelIndex = LeftPanelOption.HOME;

  @override
  void initState() {
    Log.d(TAG, "initiating");
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      AuthUtil.getToken().then((String? token) {
        Log.d(TAG, "token: $token");
        if (token == null || token == "") {
          Log.d(TAG, "Token not found poping to auth screen");
          Navigator.of(ctx).pop();
        }
      });
    });
  }

  _switchMidPanelIndex(LeftPanelOption option) {
    setState(() {
      midPanelIndex = option;
    });
  }

  void _onBloodPostCreated() {
    setState(() {
      Log.d(TAG, "_onBloodPostCreated");
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      appBar: AppBar(
        title: Text("Blood Donors",
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: !_isInit || true
          ? SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .2,
                    child: Container(
                      child: LeftPanel(
                        midPanelChangeCallback: _switchMidPanelIndex,
                        onBloodPostCreated: _onBloodPostCreated,
                      ),
                      //decoration: BoxDecoration(color: Colors.amberAccent),
                    ),
                  ),
                  VerticalDivider(
                    width: MediaQuery.of(context).size.width * .005,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * (.59+.2),
                    child: Container(
                      child: MidPanel(midPanelIndex),
                      decoration: BoxDecoration(color: Color(0xe5e5e5)),
                    ),
                  ),
                  /* VerticalDivider(
                    width: MediaQuery.of(context).size.width * .005,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .2,
                    child: Container(
                      child: Text("first part"),
                      //decoration: BoxDecoration(color: Colors.amberAccent),
                    ),
                  ), */
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
