import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/notif.dart';
import '../models/user.dart';
import '../providers/app_state.dart';
import '../utils/streams.dart';
import './no_notifications.dart';

class NotificationsStream extends StatelessWidget {
  const NotificationsStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PPUser currentUser =
        Provider.of<AppState>(context, listen: false).currentUser;

    return StreamBuilder<List<Notif>>(
        stream: getUsersNotifications(currentUser.userID),
        builder: (BuildContext context, AsyncSnapshot<List<Notif>> snapshot) {
          return NoNotifications();
        });
  }
}
