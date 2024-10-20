import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/app_state.dart';
import '../utils/messages.dart';
import '../utils/notifications.dart';

class GetStamp extends StatefulWidget {
  const GetStamp({Key? key}) : super(key: key);

  @override
  State<GetStamp> createState() => _GetStampState();
}

class _GetStampState extends State<GetStamp> {
  @override
  Widget build(BuildContext context) {
    PPUser currentUser =
        Provider.of<AppState>(context, listen: false).currentUser;

    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.8,
    );
  }
}
