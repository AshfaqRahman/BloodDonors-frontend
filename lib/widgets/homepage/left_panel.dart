import 'dart:convert';

import 'package:bms_project/modals/blood_post_model.dart';
import 'package:bms_project/providers/blood_post_provider.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/screen/blood_post_view_screen.dart';
import 'package:bms_project/utils/auth_util.dart';
import 'package:bms_project/utils/dummy.dart';
import 'package:bms_project/utils/token.dart';
import 'package:bms_project/widgets/common/margin.dart';
import 'package:bms_project/widgets/common/profile_picture.dart';
import 'package:bms_project/widgets/homepage/left_panel/create_donation.dart';
import 'package:bms_project/widgets/homepage/left_panel/create_post.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
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
  final Function onBloodPostCreated;
  const LeftPanel({
    Key? key,
    required this.midPanelChangeCallback,
    required this.onBloodPostCreated,
  }) : super(key: key);

  @override
  _LeftPanelState createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  LeftPanelOption _selectedDestination = LeftPanelOption.HOME;
  late BuildContext ctx;

  bool _initState = false;

  Color? userNameTextColor;

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
    /* {
      'index': LeftPanelOption.EVENTS,
      'icon': FontAwesomeIcons.calendar,
      'title': "Events"
    },
    {
      'index': LeftPanelOption.BOOKMARKS,
      'icon': FontAwesomeIcons.bookmark,
      'title': "Bookmarks"
    }, */
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

  void initSate(BuildContext context) {
    this.ctx = context;
    userNameTextColor = Theme.of(context).textTheme.headline6?.color;
    buttons = [
      {
        'text': 'Create blood post',
        'onPress': () async {
          ProviderResponse result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                content: CreatePost(),
              );
            },
          );
          widget.onBloodPostCreated();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 15),
              // width: MediaQuery.of(context).size.width * 0.2,
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.7,
                  right: 20,
                  bottom: 20),
              behavior: SnackBarBehavior.floating,
              content: Text(result.message),
              action: (result.data != null)
                  ? SnackBarAction(
                      label: 'View',
                      onPressed: () {
                        Navigator.of(context).pushNamed(BloodPostScreen.route,
                            arguments: result.data);
                      },
                    )
                  : null,
            ),
          );
        }
      },
      {
        'text': 'Add donation',
        'onPress': () async {
          ProviderResponse result = await showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: AddDonationDialog(),
                );
              });
        }
      },
    ];
  }

  void setSelectDestination(LeftPanelOption index) {
    if (index == LeftPanelOption.LOGOUT) {
      Navigator.of(context).pushNamed(AuthScreen.route);
      AuthUtil.logout();
      return;
    }

    setState(() {
      //print(index);
      userNameTextColor =
          (index == LeftPanelOption.PROFILE) // if profile name is selected
              ? Theme.of(ctx).primaryColor
              : Theme.of(ctx).textTheme.headline6?.color;

      _selectedDestination = index;
      widget.midPanelChangeCallback(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    if (!_initState) initSate(context);

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
                      userNameTextColor ?? Colors.black, setSelectDestination),
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
                      onTap: () => setSelectDestination(index),
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
              child: FutureBuilder(
                future: AuthToken.parseUserName(),
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    String username = snapshot.data ?? "";
                    return ProfilePictureFromName(
                        name: username,
                        radius: 30,
                        fontsize: 15,
                        characterCount: 2);
                  } else {
                    return Container();
                  }
                },
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
