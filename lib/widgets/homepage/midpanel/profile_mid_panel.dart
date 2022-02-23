import 'package:bms_project/modals/donation_model.dart';
import 'package:bms_project/modals/user_model.dart';
import 'package:bms_project/providers/donation_provider.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/providers/users_provider.dart';
import 'package:bms_project/utils/constant.dart';
import 'package:bms_project/utils/token.dart';
import 'package:bms_project/widgets/common/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileMidPanel extends StatefulWidget {
  const ProfileMidPanel({Key? key}) : super(key: key);

  @override
  _ProfileMidPanelState createState() => _ProfileMidPanelState();
}

class _ProfileMidPanelState extends State<ProfileMidPanel> {
  Future<List<Donation>> _fetchDonations() async {
    ProviderResponse response =
        await Provider.of<DonationProvider>(context, listen: false)
            .getDonations(await AuthToken.parseUserId());
    List<Donation> donationList = [];
    return donationList;
  }

  @override
  Widget build(BuildContext context) {
    /* return Container(
      child: FutureBuilder(
        future: _fetchDonations(),
        builder: (context, snapshot) {
          return Center(
            child: Text("Profile"),
          );
        },
      ),
    ); */
    return FutureBuilder(
        future:
            Provider.of<UsersProvider>(context, listen: false).getUserData(),
        builder: (context, AsyncSnapshot<ProviderResponse> snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          ProviderResponse response = snapshot.data!;
          ProfileData profileData = response.data;

          return Container(
            padding: EdgeInsets.only(top: 12),
            height: double.infinity,
            color: Constants.hexToColor("#f6f6f6"),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UserInfoWidget(profileData: profileData),
                  // the tab bar with two items
                  UserCreatedDataWidget()
                ],
              ),
            ),
          );
        });
  }
}

class UserCreatedDataWidget extends StatelessWidget {
  const UserCreatedDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: DefaultTabController(
        // https://stackoverflow.com/questions/63304112/how-to-create-a-tab-bar-at-center-of-the-screen-in-flutter
        length: 2,
        child: SizedBox(
          height: 50,
          child: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).primaryColor,
            bottom: const TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: "Blood Posts",
                ),
                Tab(
                  text: "Donations",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  UserInfoWidget({
    Key? key,
    required this.profileData,
  }) : super(key: key);

  ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    //return Center(child: Text(profileData.name),);
    return Container(
      width: double.infinity,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfilePictureFromName(
                  name: profileData.name,
                  radius: 25,
                  fontsize: 16,
                  characterCount: 2),
              SizedBox(width: 12),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          profileData.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      profileData.bloodGroup,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InfoWithIconWidget(
                      text: profileData.location.displayName,
                      icon: const Icon(
                        FontAwesomeIcons.mapMarkerAlt,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InfoWithIconWidget(
                      text:
                          "Joined ${DateFormat("dd MMM yyyy").format(profileData.created)}",
                      icon: const Icon(
                        FontAwesomeIcons.calendar,
                        size: 14,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoWithIconWidget extends StatelessWidget {
  const InfoWithIconWidget({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }
}
