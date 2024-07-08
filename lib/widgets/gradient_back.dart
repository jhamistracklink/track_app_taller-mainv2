import 'package:flutter/material.dart';

class GradientBack extends StatelessWidget {

  String title;
  double? height;

  GradientBack({Key? key, this.title = "", this.height});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (height == null) {
      height = screenHeight;
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color(0xFF1c3651),
              Color(0xFF1d3043)
              // Color(0xFF41C0F0),
              // Color(0xFF41C0F0)
            ],
            begin: FractionalOffset(0.2, 0.0),
            end: FractionalOffset(1.0, 0.6),
            stops: [0.0, 0.6],
            tileMode: TileMode.clamp
        )
      ),

      child: FittedBox(
        fit: BoxFit.none,
        alignment: Alignment(-1.5, -0.8),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            borderRadius: BorderRadius.circular(screenHeight / 2)
          ),
        ),
      ),

      // child: Text(
      //   title,
      //   style: TextStyle(
      //     color: Colors.white,
      //     fontSize: 30.0,
      //     fontFamily: "Lato",
      //     fontWeight: FontWeight.bold
      //   ),
      // ),
      //
      alignment: Alignment(-0.9, -0.6),
    );
  }
}