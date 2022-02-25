import 'package:bms_project/modals/osm_model.dart';
import 'package:bms_project/modals/user_model.dart';
import 'package:bms_project/providers/search_provider.dart';
import 'package:bms_project/screen/profile_screen.dart';
import 'package:bms_project/utils/debug.dart';
import 'package:bms_project/widgets/common/blood_group_selection.dart';
import 'package:bms_project/widgets/common/location_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/provider_response.dart';
import '../../common/my_text_field.dart';
import '../../common/profile_picture.dart';

class BloodSearchMidPanel extends StatefulWidget {
  const BloodSearchMidPanel({Key? key}) : super(key: key);

  @override
  _BloodSearchMidPanelState createState() => _BloodSearchMidPanelState();
}

class _BloodSearchMidPanelState extends State<BloodSearchMidPanel> {
  static String TAG = "BloodSearchMidPanel";

  String? selectedBloodGroup;
  String? radius;
  OsmLocation? selectedLocation;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ThemeData themeData = Theme.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Card(
          child: Container(
            width: width * .3,
            color: Colors.white,
            padding: EdgeInsets.all(15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: BloodGroupDropdown(
                            selectedBloodGroup: null,
                            onBGSelected: (String bg) {
                              selectedBloodGroup = bg;
                              Log.d(TAG, "selected blood group: $bg");
                            }),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          child: MyTextField(
                        hint: "Radius in km",
                        onSubmitText: (value) {
                          radius = value;
                        },
                        vanishTextOnSubmit: false,
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: InputLocation(
                            onLocationSelected: (OsmLocation location) {
                          Log.d(TAG,
                              "selected location: ${location.displayName}");
                          selectedLocation = location;
                        }),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {}); // refresh the screen
                            },
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  if (selectedBloodGroup != null &&
                      radius != null &&
                      selectedLocation != null)
                    FutureBuilder(
                        future: _searchBlood(
                            selectedBloodGroup!, radius!, selectedLocation!),
                        builder: (context,
                            AsyncSnapshot<List<UserBloodSearchResult>>
                                snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          List<UserBloodSearchResult>? result = snapshot.data;

                          return result == null || result.isEmpty
                              ? Text(
                                  "No user found with $selectedBloodGroup blood!")
                              : Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        "Total ${result.length} users found with $selectedBloodGroup blood."),
                                    const Divider(
                                      thickness: 1,
                                      height: 5,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    RenderSearchResultWidget(
                                      userList: result,
                                    )
                                  ],
                                );
                        })
                ]),
          ),
        ),
      ),
    );
  }

  Future<List<UserBloodSearchResult>> _searchBlood(
      String? bloogGroup, String? radius, OsmLocation? location) async {
    List<UserBloodSearchResult> data = [];

    if (bloogGroup == null || radius == null || location == null) {
      return data;
    }

    ProviderResponse response =
        await Provider.of<SearchProvider>(context, listen: false)
            .searchBlood(bloogGroup, radius, location);
    data = response.success ? response.data ?? [] : [];
    return data;
  }
}

class RenderSearchResultWidget extends StatelessWidget {
  static String TAG = "RenderSearchResultWidget";
  const RenderSearchResultWidget({
    Key? key,
    required this.userList,
  }) : super(key: key);

  final List<UserBloodSearchResult> userList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        if (index == userList.length) return Container();
        UserBloodSearchResult user = userList[index];
        return InkWell(
          onTap: () {
            Log.d(TAG, "selected user ${user.name} , id: ${user.id}");
            Navigator.of(context)
                .pushNamed(ProfileScreen.route, arguments: user.id);
          },
          child: UserItem(userData: user),
        );
      }),
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: userList.length + 1,
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({Key? key, required this.userData}) : super(key: key);

  final UserBloodSearchResult userData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        ProfilePictureFromName(
          name: userData.name,
          radius: 20,
          fontsize: 14,
          characterCount: 2,
          random: true,
        ),
        SizedBox(
          width: 20,
        ),
        Text(userData.name)
      ],
    );
  }
}
