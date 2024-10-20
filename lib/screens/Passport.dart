import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/3d_viewer.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/auth_state.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/sidebar.dart';

class Passports extends StatefulWidget {
  const Passports({Key? key}) : super(key: key);

  @override
  _PassportsState createState() => _PassportsState();
}

class _PassportsState extends State<Passports> {
  PageController? _pageController;
  Timer? _timer;
  int _activePage = 0;

  List<String> images = [
    'assets/images/img1.png',
    'assets/images/img2.png',
    'assets/images/img3.png',
    'assets/images/img4.png',
    'assets/images/img5.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _activePage);

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController != null) {
        int nextPage = (_activePage + 1) % images.length;
        _pageController!.animateToPage(nextPage,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBarMenu(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Consumer<AuthState>(
          builder: (context, authState, child) {
            PPUser? currentUser = authState.currentUser;
            if (currentUser == null) {
              return Text(
                'Cargando...',
                style: TextStyle(color: Colors.black),
              );
            }
            return Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          tooltip: MaterialLocalizations.of(context)
                              .openAppDrawerTooltip,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 45),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentUser.userName,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        Icon(
                          Icons.account_circle,
                          color: Colors.black,
                          size: 36,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: images.length,
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _activePage = page;
                  });
                },
                itemBuilder: (context, pagePosition) {
                  return GestureDetector(
                    child: slider(images, pagePosition, context),
                    onTap: () async {
                      // Aquí puedes agregar código para mostrar un diálogo si lo necesitas
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: Text(
                'Bienvenido a la Realidad Aumentada de Kotosh',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Objetos:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 260,
                    height: 200,
                    child: Stack(
                      children: [
                        ThreeDViewer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
      bottomNavigationBar: BottomMenuBar(),
    );
  }
}

Widget slider(List<String> images, int pagePosition, BuildContext context) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 300),
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      image: DecorationImage(
        scale: 0.75,
        image: AssetImage(images[pagePosition]),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
