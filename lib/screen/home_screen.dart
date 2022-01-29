import 'package:bms_project/modals/user.dart';
import 'package:bms_project/providers/users.dart';
import 'package:bms_project/widgets/homepage/left_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/js.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BuildContext ctx;
  var _isInit = true;
  var users;

  @override
  void initState() {
    print("initiating");
    // if (_isInit) {
    //   final value = Provider.of<Users>(context as BuildContext).getUserData();
    // }
    // _isInit = false;
    // super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   var users = Provider.of<Users>(ctx);
    //   print(users.user);
    //   this._isInit = false;
    // });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      users = Provider.of<Users>(ctx, listen: false);
      await users.getUserData();
      var future = Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          _isInit = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      appBar: AppBar(
        title: !_isInit ? Text(users.user.name) : Text(''),
        automaticallyImplyLeading: false,
      ),
      body: !_isInit
          ? SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .2,
                    child: Container(
                      child: LeftPanel(),
                      decoration: BoxDecoration(color: Colors.amberAccent),
                    ),
                  ),
                  Container(
                    child: VerticalDivider(
                      width: MediaQuery.of(context).size.width * .005,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .59,
                    child: Container(
                      child: Text("first part"),
                      decoration: BoxDecoration(color: Colors.amberAccent),
                    ),
                  ),
                  Container(
                    child: VerticalDivider(
                      width: MediaQuery.of(context).size.width * .005,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .2,
                    child: Container(
                      child: Text("first part"),
                      decoration: BoxDecoration(color: Colors.amberAccent),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
