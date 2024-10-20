import 'package:flutter/material.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/notifications_stream.dart';
import '../widgets/sidebar.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationsStream(),
      bottomNavigationBar: BottomMenuBar(),
    );
  }
}
