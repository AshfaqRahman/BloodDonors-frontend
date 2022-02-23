import 'package:bms_project/modals/notification_model.dart';
import 'package:bms_project/providers/notification_provider.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/utils/constant.dart';
import 'package:bms_project/widgets/common/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationMidPanel extends StatefulWidget {
  const NotificationMidPanel({Key? key}) : super(key: key);

  @override
  _NotificationMidPanelState createState() => _NotificationMidPanelState();
}

class _NotificationMidPanelState extends State<NotificationMidPanel> {
  Future<List<NotificationModel>> _fetchNotifaction() async {
    ProviderResponse response =
        await Provider.of<NotificationProvider>(context, listen: false)
            .getNotications();

    List<NotificationModel> list = response.success ? response.data ?? [] : [];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of<NotificationProvider>(context, listen: false).getNotications();
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: FutureBuilder(
        future: _fetchNotifaction(),
        builder: (context, AsyncSnapshot<List<NotificationModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) return const NoNotificationWidget();

          List<NotificationModel> notificationList = snapshot.data ?? [];
          if (notificationList.isEmpty) return const NoNotificationWidget();

          return ListView.separated(
              itemBuilder: ((context, index) {
                return index == notificationList.length
                    ? Container()
                    : NotificationItem(
                        notificationModel: notificationList[index]);
              }),
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: notificationList.length + 1);
        },
      ),
    );
  }
}

class NoNotificationWidget extends StatelessWidget {
  const NoNotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No notification.",
        style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 20),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key, required this.notificationModel})
      : super(key: key);

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(children: [
        ProfilePictureFromName(
            name: notificationModel.actorName,
            radius: 25,
            fontsize: 15,
            characterCount: 2),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMessasgeText(context, notificationModel)??Container(),
            Text(
              Constants.dateFormat.format(notificationModel.created.toLocal()),
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        )
      ]),
    );
  }

  RichText? buildMessasgeText(context, NotificationModel model) {
    switch (model.type.toLowerCase()) {
      case "message":
        return RichText(
          text: TextSpan(
              style:
                  Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
              children: [
                TextSpan(text: notificationModel.message),
                TextSpan(
                  text: " from ${notificationModel.actorName}",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ]),
        );
      default:
        RichText(
          text: TextSpan(
              style:
                  Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
              children: [
                TextSpan(
                  text: "${notificationModel.actorName} ",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextSpan(text: notificationModel.message)
              ]),
        );
    }
  }
}
