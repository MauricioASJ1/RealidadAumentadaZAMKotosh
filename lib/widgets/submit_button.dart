import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class CustomSubmitButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  CustomSubmitButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 138, 166, 143),
            Color.fromARGB(255, 0, 166, 36)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(vertical: 5), // Aumenta el tamaño del botón
      child: GFButton(
        onPressed: () {
          onPressed();
        },
        text: label,
        textStyle: TextStyle(
          fontSize: 18, // Aumenta el tamaño del texto
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        shape: GFButtonShape.pills,
        size: GFSize.LARGE,
        fullWidthButton: true,
        color: Colors
            .transparent, // Hace que el color del botón sea transparente para mostrar el degradado
      ),
    );
  }
}
