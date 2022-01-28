import 'package:bms_project/modals/user.dart';
import 'package:bms_project/providers/users.dart';
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
      print("here");
      users = Provider.of<Users>(ctx, listen: false);
      await users.getUserData();
      var future = Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          print(users.user.email);
          _isInit = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    print('building');
    print(_isInit);

    // final args = ModalRoute.of(context)!.settings.arguments as User;
    // print(args.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(users.user.name),
      ),
      body: !_isInit
          ? SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      child: Text("first part"),
                      decoration: BoxDecoration(color: Colors.amberAccent),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                      child: Text("first part"),
                      decoration: BoxDecoration(color: Colors.amberAccent),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
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
