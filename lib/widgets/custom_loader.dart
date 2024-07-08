import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader {
  static Widget circleLoader({color}) {
    return Container(
      width: null,
      height: null,
      child: SpinKitFadingCircle(
        color: color ?? Colors.white,
        size: 50.0,
      ),
      decoration: new BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.40)
      ),
    );
  }
}