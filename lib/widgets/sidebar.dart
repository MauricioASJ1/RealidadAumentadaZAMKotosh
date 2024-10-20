import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/app_state.dart';
import '../providers/auth_state.dart';
import './sidebar_tile.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu({Key? key}) : super(key: key);

  @override
  State<SideBarMenu> createState() => SideBarMenuState();
}

class SideBarMenuState extends State<SideBarMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PPUser currentUser =
        Provider.of<AppState>(context, listen: false).currentUser;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        Size size = MediaQuery.of(context).size;
        return Drawer(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Container(
            color: Colors.black,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  margin: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(2), // Espaciado para el borde
                        decoration: BoxDecoration(
                          color: Colors.white, // Color del borde
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(
                          width: 10), // Espaciado entre foto y nombre
                      Text(
                        currentUser.userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SideBarTile(
                  icon: Icons.account_circle_rounded,
                  title: 'Perfil',
                  onTap: () {
                    //appState.setpageIndex = 5;
                    //Navigator.pushReplacementNamed(context, '/Profile');
                  },
                ),
                SideBarTile(
                  icon: Icons.notification_add_rounded,
                  title: 'Notificaciones',
                  onTap: () {
                    appState.setpageIndex = 1;
                    Navigator.pushReplacementNamed(context, '/Notifications');
                  },
                ),
                SideBarTile(
                  icon: Icons.menu_book,
                  title: 'Mapa',
                  onTap: () {
                    appState.setpageIndex = 2;
                    Navigator.pushReplacementNamed(context, '/Home');
                  },
                ),
                SideBarTile(
                  icon: Icons.park_outlined,
                  title: 'ZAM Kotosh',
                  onTap: () {
                    //appState.setpageIndex = 10;
                    //Navigator.pushReplacementNamed(context, '/ParkDetails');
                  },
                ),
                ListTile(
                  title: Text(
                    'Ajuste y privacidad',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    // show no index on bottom bar
                    //appState.setpageIndex = 5;
                    //Navigator.pushReplacementNamed(context, '/Settings');
                  },
                ),
                ListTile(
                  title: Text(
                    'Salir',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    AuthState().logout();
                    Navigator.pushReplacementNamed(context, '/Welcome');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SideBarTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SideBarTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
