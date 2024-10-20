import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeProfileField extends StatefulWidget {
  final String label;
  final Future<dynamic> Function() onChange;

  const ChangeProfileField(
      {Key? key, required this.label, required this.onChange})
      : super(key: key);

  @override
  State<ChangeProfileField> createState() => _ChangeProfileFieldState();
}

class _ChangeProfileFieldState extends State<ChangeProfileField> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String label = widget.label;
    return Container(
      width: size.width * 0.8,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                  clipBehavior: Clip.none, // Reemplaza el uso de overflow
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: GoogleFonts.mulish().fontFamily,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Text("Submit"),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                    0xFF8eb057), // Color de fondo del botón
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.mulish().fontFamily,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF8eb057), // Color de fondo del botón
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
