import 'package:bms_project/providers/blood_post_provider.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/widgets/post_screen/blood_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../modals/blood_post_model.dart';

class HomeMidPanel extends StatefulWidget {
  const HomeMidPanel({Key? key}) : super(key: key);

  @override
  _HomeMidPanelState createState() => _HomeMidPanelState();
}

class _HomeMidPanelState extends State<HomeMidPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder(
        future:
            Provider.of<BloodPostProvider>(context, listen: false).getPosts(),
        builder: (BuildContext ctx, AsyncSnapshot<ProviderResponse> snapshot) {
          if (snapshot.hasData) {
            List<BloodPost> postList =
                snapshot.data!.success ? snapshot.data!.data : [];
            return Container(
              //width: MediaQuery.of(context).size.width*0.55,
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ListView(
                controller: ScrollController(),
                children: postList.map((BloodPost post) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
                    child: BloodPostWidget(postData: post,)
                    );
                }).toList(),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
