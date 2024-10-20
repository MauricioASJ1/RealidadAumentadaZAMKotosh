import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_state.dart';
import '../providers/app_state.dart';
import '../models/user.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/sidebar.dart';
import '../widgets/map.dart';
import '../widgets/profile_card.dart';
import 'ARView.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool _switchView = true;

  @override
  void initState() {
    // init state
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    _populateCurrentUserInfo();
    //});
    super.initState();
  }

  void toggleSwitch(bool value) {
    setState(() {
      _switchView = !_switchView;
    });
  }

  Future<void> _populateCurrentUserInfo() async {
    // PPUser user = await AuthState().getCurrentUserModel();
    setState(() {
      // Get user data from Firebase
      //Provider.of<AppState>(context, listen: false).currentUser = user;
    });
  }

  @override
  void dispose() {
    // dispose controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(children: [
          SizedBox(height: size.height * 0.04),
          Expanded(
            child: Stack(children: [Container(child: Map())]),
          )
        ]),
      ),
      bottomNavigationBar: BottomMenuBar(),
    );
  }
}
