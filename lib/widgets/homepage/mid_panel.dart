import 'package:bms_project/screen/auth_screen.dart';
import 'package:bms_project/widgets/homepage/left_panel.dart';
import 'package:bms_project/widgets/homepage/midpanel/home_mid_panel.dart';
import 'package:bms_project/widgets/homepage/midpanel/message_mid_panel.dart';
import 'package:flutter/material.dart';

class MidPanel extends StatefulWidget {
  final LeftPanelOption option;
  const MidPanel(this.option, {Key? key}) : super(key: key);

  @override
  _MidPanelState createState() => _MidPanelState();
}

class _MidPanelState extends State<MidPanel> {
  @override
  Widget build(BuildContext context) {
    switch (widget.option) {
      case LeftPanelOption.PROFILE:
        return Container(
          child: Text("Profile"),
        );
      case LeftPanelOption.HOME:
        return HomeMidPanel();
      case LeftPanelOption.MESSAGE:
        return Container(
          child: ChatMidPanel(),
        );
      case LeftPanelOption.NOTIFICATION:
        return Container(
          child: Text("Notification"),
        );
      case LeftPanelOption.SEARCH_BLOOD:
        return Container(
          child: Text("s b"),
        );
      case LeftPanelOption.EVENTS:
        return Container(
          child: Text("events"),
        );
      case LeftPanelOption.BOOKMARKS:
        return Container(
          child: Text("bk"),
        );
      case LeftPanelOption.SETTINGS:
        return Container(
          child: Text("setto"),
        );
      default:
        return Container();
    }
    ;
  }
}
