import 'package:flutter/material.dart';

class EditProfileButton extends StatefulWidget {
  EditProfileButton({Key? key}) : super(key: key);

  @override
  State<EditProfileButton> createState() => _EditProfileButtonState();
}

class _EditProfileButtonState extends State<EditProfileButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/Settings');
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.0),
          ),
          elevation: 0.0,
          padding: EdgeInsets.all(0.0),
          backgroundColor: Colors
              .transparent, // Fondo transparente para mostrar el degradado
          shadowColor: Colors.transparent, // Quitar sombra
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFFe05e4a), Color(0xFFe7b732)],
            ),
            borderRadius: BorderRadius.circular(80.0),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "Edit Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
