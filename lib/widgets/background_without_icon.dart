import 'package:flutter/material.dart';

class BackgroundWithoutIcon extends StatelessWidget {
  final Widget child;

  const BackgroundWithoutIcon({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Container para el fondo negro
          Container(
            color: Colors.black.withOpacity(0.8),
          ),
          child,
        ],
      ),
    );
  }
}
