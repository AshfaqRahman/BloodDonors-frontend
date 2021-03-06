import 'package:bms_project/screen/auth_screen.dart';
import 'package:bms_project/utils/token.dart';
import 'package:bms_project/widgets/homepage/left_panel.dart';
import 'package:bms_project/widgets/homepage/midpanel/blood_search_mid_panel.dart';
import 'package:bms_project/widgets/homepage/midpanel/home_mid_panel.dart';
import 'package:bms_project/widgets/homepage/midpanel/message_mid_panel.dart';
import 'package:bms_project/widgets/homepage/midpanel/notification_mid_panel.dart';
import 'package:bms_project/widgets/homepage/midpanel/profile_mid_panel.dart';
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
        return FutureBuilder(
          future: AuthToken.parseUserId(),
          builder: (context, AsyncSnapshot<String> snapshot){
            if(!snapshot.hasData) return Container();
            return  ProfileMidPanel(userId: snapshot.data!,);
          },
          );
      case LeftPanelOption.HOME:
        return HomeMidPanel();
      case LeftPanelOption.MESSAGE:
        return const ChatMidPanel();
      case LeftPanelOption.NOTIFICATION:
        return const NotificationMidPanel();
      case LeftPanelOption.SEARCH_BLOOD:
        return BloodSearchMidPanel();
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
