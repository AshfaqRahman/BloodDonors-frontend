import 'package:bms_project/modals/user.dart';
import 'package:bms_project/providers/users.dart';
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
  late BuildContext ctx;
  var _isInit = true;
  var users;

  LeftPanelOption midPanelIndex = LeftPanelOption.HOME;

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
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
    //   users = Provider.of<Users>(ctx, listen: false);
    //   await users.getUserData();
    //   var future = Future.delayed(const Duration(milliseconds: 2000), () {
    //     setState(() {
    //       _isInit = false;
    //     });
    //   });
    // });
  }

  _switchMidPanelIndex(LeftPanelOption option) {
    setState(() {
      midPanelIndex = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ctx = context;

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
                      child: LeftPanel(context, _switchMidPanelIndex),
                      //decoration: BoxDecoration(color: Colors.amberAccent),
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
                      child: MidPanel(midPanelIndex),
                      //decoration: BoxDecoration(color: Colors.amberAccent),
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
                      //decoration: BoxDecoration(color: Colors.amberAccent),
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
