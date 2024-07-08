import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {

  final String hintText;
  final String labelText;
  final bool isPassword;
  final bool isValid;
  final TextInputType inputType;
  final TextEditingController controller;
  int maxLines;

  TextInput({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    required this.inputType,
    this.maxLines = 1,
    this.isPassword = false,
    this.isValid = false,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(right: 20.0, left: 20.0),
          margin: EdgeInsets.only(bottom: 8.0),
          child: Text(labelText,
            style: TextStyle(color: Colors.white, fontSize: 14.0),
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: 20.0, left: 20.0),
          child: TextField(
            obscureText: isPassword,
            controller: controller,
            keyboardType: inputType,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Lato',
              color: Colors.white,
            ),
            decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF152130),
                hintText: hintText,
                errorText: this.isValid ? null : 'Este campo no puede ser vacio',
                hintStyle: TextStyle(color: Color(0xFF959595)),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF0675cd), width: 0.8),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0675cd), width: 0.8),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))
                )
            ),
          ),
        )
      ],
    );
  }
}