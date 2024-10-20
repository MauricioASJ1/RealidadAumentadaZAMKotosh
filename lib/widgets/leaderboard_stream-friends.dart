import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/app_state.dart';
import '../utils/streams.dart';
import '../utils/utils.dart';
import './user_search_result.dart';

class FriendsLeaderboardStream extends StatelessWidget {
  const FriendsLeaderboardStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PPUser currentUser =
        Provider.of<AppState>(context, listen: false).currentUser;

    return StreamBuilder<List<PPUser>>(
        stream: getTopFriends(),
        builder: (BuildContext context, AsyncSnapshot<List<PPUser>> snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              controller: ScrollController(),
              shrinkWrap: true,
            );
          } else {
            return Container();
          }
        });
  }
}
