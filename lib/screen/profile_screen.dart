import 'package:bms_project/utils/debug.dart';
import 'package:bms_project/widgets/homepage/midpanel/profile_mid_panel.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static String route = "/profile";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static String TAG = "ProfileScreen";
  String? userId;

  void getUserIdFromNavigator() {
    userId ??= ModalRoute.of(context)!.settings.arguments as String;
    Log.d(TAG, " user id: $userId");
  }

  @override
  Widget build(BuildContext context) {
    getUserIdFromNavigator();
    return Scaffold(
      appBar: AppBar(
        title: Text("Blood Donors",
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: ProfileMidPanel(
        userId: userId!,
      ),
    );
  }
}
