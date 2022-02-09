import 'package:bms_project/screen/post_screen.dart';
import 'package:bms_project/widgets/common/margin.dart';
import 'package:bms_project/widgets/homepage/left_panel/create_post.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screen/auth_screen.dart';

enum LeftPanelOption {
  PROFILE,
  HOME,
  MESSAGE,
  NOTIFICATION,
  SEARCH_BLOOD,
  EVENTS,
  BOOKMARKS,
  SETTINGS,
  LOGOUT,
}

class LeftPanel extends StatefulWidget {
  final Function midPanelChangeCallback;
  final BuildContext context;
  const LeftPanel(this.context, this.midPanelChangeCallback, {Key? key})
      : super(key: key);

  @override
  _LeftPanelState createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  LeftPanelOption _selectedDestination = LeftPanelOption.HOME;

  Color? userNameTextColor;

  @override
  void initState() {
    userNameTextColor = Theme.of(widget.context).textTheme.headline6?.color;
    buttons = [
      {
        'text': 'Create blood post',
        'onPress': () async {
          var result = await showDialog(
            context: widget.context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: CreatePost(),
              );
            },
          );
          print("after popping ${result}");
          ScaffoldMessenger.of(widget.context).showSnackBar(
            SnackBar(
              // width: MediaQuery.of(context).size.width * 0.2,
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.7,
                  right: 20,
                  bottom: 20),
              behavior: SnackBarBehavior.floating,
              content: Text(result['message']),
              action: (result['data'] != null)
                  ? SnackBarAction(
                      label: 'Show',
                      onPressed: () {
                        Navigator.of(context).pushNamed(BloodPostScreen.route,
                            arguments: result['data']);
                      },
                    )
                  : null,
            ),
          );
        }
      },
      {'text': 'Add donation', 'onPress': () {}},
    ];
    super.initState();
  }

  void selectDestination(LeftPanelOption index) {
    if (index == LeftPanelOption.LOGOUT) {
      Navigator.of(context).pushNamed(AuthScreen.route);
      return;
    }

    setState(() {
      //print(index);
      userNameTextColor =
          (index == LeftPanelOption.PROFILE) // if profile name is selected
              ? Theme.of(widget.context).primaryColor
              : Theme.of(widget.context).textTheme.headline6?.color;

      _selectedDestination = index;
      widget.midPanelChangeCallback(index);
    });
  }

  List<Map<String, dynamic>> menu = [
    {
      'index': LeftPanelOption.HOME,
      'icon': FontAwesomeIcons.home,
      'title': "Home"
    },
    {
      'index': LeftPanelOption.MESSAGE,
      'icon': FontAwesomeIcons.commentAlt,
      'title': "Message"
    },
    {
      'index': LeftPanelOption.NOTIFICATION,
      'icon': FontAwesomeIcons.bell,
      'title': "Notification"
    },
    {
      'index': LeftPanelOption.SEARCH_BLOOD,
      'icon': FontAwesomeIcons.search,
      'title': "Search blood"
    },
    {
      'index': LeftPanelOption.EVENTS,
      'icon': FontAwesomeIcons.calendar,
      'title': "Events"
    },
    {
      'index': LeftPanelOption.BOOKMARKS,
      'icon': FontAwesomeIcons.bookmark,
      'title': "Bookmarks"
    },
    {
      'index': LeftPanelOption.SETTINGS,
      'icon': FontAwesomeIcons.cog,
      'title': "Settings"
    },
    {
      'index': LeftPanelOption.LOGOUT,
      'icon': FontAwesomeIcons.signOutAlt,
      'title': "Logout"
    },
  ];

  List<Map<String, dynamic>>? buttons;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Drawer(
              elevation: 0.0,
              child: ListView(
                // Important: Remove any padding from the ListView.
                shrinkWrap: true,
                // padding: EdgeInsets.zero,
                children: <Widget>[
                  UserWidget(
                      userNameTextColor ?? Colors.black, selectDestination),
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  ...menu.asMap().entries.map((item) {
                    //int index = item.key;
                    Map value = item.value;
                    LeftPanelOption index = value['index'];
                    return ListTile(
                      leading: Icon(value['icon']),
                      title: Text(value['title']),
                      selected: _selectedDestination == index,
                      onTap: () => selectDestination(index),
                    );
                  }).toList(),
                  const VerticalSpacing(15),
                  ...buttons!.asMap().entries.map((item) {
                    Map value = item.value;
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              //side: BorderSide(color: Colors.red)
                            ),
                          ),
                        ),
                        onPressed: value['onPress'],
                        child: Text(value['text']),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserWidget extends StatelessWidget {
  final Color userNameTextColor;
  const UserWidget(this.userNameTextColor, this.onProfileTap, {Key? key})
      : super(key: key);

  final Function onProfileTap;

  @override
  Widget build(BuildContext context) {
    print("drawing UserWidget");
    return InkWell(
      onTap: () {
        onProfileTap(LeftPanelOption.PROFILE);
      },
      // radius: 20,
      //splashColor: Colors.grey,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(children: [
          CircleAvatar(
            //radius: 200,
            child: ClipOval(
              child: Image.network(
                'https://avatars.githubusercontent.com/u/55390870?v=4',
              ),
            ),
          ),
          const HorizontalSpacing(20),
          FutureBuilder(
            future: parseUserNameFromToken(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Text(
                snapshot.data ?? "",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold, color: userNameTextColor),
              );
            },
          )
        ]),
      ),
    );
  }

  Future<String> parseUserNameFromToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken['name'] ?? "";
  }
}
