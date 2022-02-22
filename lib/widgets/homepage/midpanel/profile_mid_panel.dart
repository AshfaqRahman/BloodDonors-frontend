import 'package:bms_project/modals/donation_model.dart';
import 'package:bms_project/providers/donation_provider.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/utils/token.dart';
import 'package:flutter/material.dart';
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
    return Container(
      child: FutureBuilder(
        future: _fetchDonations(),
        builder: (context, snapshot) {
          return Center(
            child: Text("Proifle"),
          );
        },
      ),
    );
  }
}
