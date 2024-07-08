import 'package:flutter/material.dart';

class ButtonBlue extends StatefulWidget {
  final String text;
  double? width = 0.0;
  double? height = 0.0;
  final VoidCallback onPressed;

  ButtonBlue({Key? key, required this.text, required this.onPressed, this.height, this.width});

  @override
  State<StatefulWidget> createState() {
    return _ButtonBlue();
  }
}

class _ButtonBlue extends State<ButtonBlue> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        margin: EdgeInsets.only(
            top: 30.0,
            left: 20.0,
            right: 20.0
        ),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(8.0, 8.0)),
            gradient: LinearGradient(
                colors: [
                  Color(0xFF2362f5), //Arriba
                  Color(0xFF2362f5) //bajo
                ],
                begin: FractionalOffset(0.2, 0.0),
                end: FractionalOffset(1.0, 0.6),
                stops: [0.0, 0.6],
                tileMode: TileMode.clamp
            )
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "Lato",
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}