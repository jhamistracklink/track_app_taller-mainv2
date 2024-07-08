import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sai_track/User/bloc/bloc_user.dart';
import 'package:sai_track/User/model/user.dart';
import 'package:sai_track/screens/home_screen.dart';
import 'package:sai_track/widgets/button_blue.dart';
import 'package:sai_track/widgets/custom_alert_dialog.dart';
import 'package:sai_track/widgets/custom_loader.dart';
import 'package:sai_track/widgets/gradient_back.dart';
import 'package:sai_track/widgets/text_input.dart';
const List<String> company = <String>['TRACKLINK','TOYOTA'];

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInScreen();
  }
}

class _SignInScreen extends State<SignInScreen> {

  bool isLoading = false;
  UserBloc userBloc = UserBloc();

  bool _userValid = true;
  bool _pwdValid = true;

  final _controllerUser = TextEditingController();
  final _controllerPassword = TextEditingController();
  String dropdownValue = company.first;

  _checkAccount(String? account){
    if(account == dropdownValue){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen(dropdownValue)), ModalRoute.withName('/home'));
    }else{
      CustomAlertDialog.showAlertDialog(context, 'Login Fallido', "La cuenta que has ingresado no pertenece a " + dropdownValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GradientBack(title: "", height: null),
          Container(
            // margin: EdgeInsets.only(top: 120.0, bottom: 20.0),
            child: ListView(
              children: [
                Container(
                  child: Center(
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Image(
                        width: 60.0,
                        height: 160.0,
                        image: AssetImage("assets/img/track-icon-new.png"),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Text("App Taller",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: "Lato",
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container( // Text Field Usuario
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: TextInput(
                    labelText: "Usuario",
                    hintText: "Escribe tu usuario",
                    inputType: TextInputType.text,
                    maxLines: 1,
                    isPassword: false,
                    isValid: _userValid,
                    controller: _controllerUser,
                  ),
                ),
                Container( // Text Field Password
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: TextInput(
                    labelText: "Contraseña",
                    hintText: "Ingresa tu contraseña",
                    inputType: TextInputType.text,
                    maxLines: 1,
                    isPassword: true,
                    isValid: _pwdValid,
                    controller: _controllerPassword,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 2.0, left: 20.0),
                  child: Text("Cuenta", style: TextStyle(color: Colors.white)),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
                  child: DropdownButton<String>(
                          isExpanded: true,
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(20)),
                          value: dropdownValue,
                          dropdownColor: Color(0xFF1c3651),
                          icon: Icon(
                            Icons.arrow_drop_down, 
                            color: Colors.white, // <-- SEE HERE
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value!;
                              // print(dropdownValue);
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          items: company.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                ),
                ButtonBlue(
                  text: "INICIA SESIÓN",
                  onPressed: () {
                    setState(() {
                      _controllerUser.text.isEmpty ? _userValid = false : _userValid = true;
                      _controllerPassword.text.isEmpty ? _pwdValid = false : _pwdValid = true;
                    });

                    if (!_userValid || !_pwdValid) {
                      return;
                    }

                    setState(() {
                      isLoading = true;
                    });

                    userBloc.signIn( new User(username: _controllerUser.text, password: _controllerPassword.text)).then( (User user) async {
                      setState(() {
                        isLoading = false;
                      });
                      print(user);
                      
                      _checkAccount(user.account);

                      userBloc.userSelectedSink.add(user);

                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString('currUser', convert.json.encode(user));

                    }, onError: (e) {
                      var errMessage = e.toString().replaceAll('Exception: ', '');

                      print("ON ERROR");
                      print(errMessage);

                      CustomAlertDialog.showAlertDialog(context, 'Login TrackApp', "¡Por favor verifica que la conexión sea estable o el usuario esté activo!");

                      setState(() {
                        isLoading = false;
                      });
                    });
                  },
                  width: 300.0,
                  height: 46.0,
                )
              ],
            ),
          ),
          isLoading ? CustomLoader.circleLoader() : Text("")
        ],
      ),
    );
  }
}