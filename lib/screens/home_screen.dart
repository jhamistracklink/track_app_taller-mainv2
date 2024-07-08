import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:sai_track/Installation/ui/screens/installation_completed_list.dart';
import 'package:sai_track/Installation/ui/screens/installation_steps_screen.dart';
import 'package:sai_track/Installation/ui/screens/toyota/installation_completed_toyota_list.dart';
import 'package:sai_track/Installation/ui/screens/toyota/installation_steps_toyota.dart';
import 'package:sai_track/User/bloc/bloc_user.dart';
import 'package:sai_track/User/model/user.dart';
import 'package:sai_track/User/ui/screens/sign_in_screen.dart';

import 'other_screen.dart';

class HomeScreen extends StatefulWidget {
  String? company;
  
  HomeScreen(String company){
    this.company = company;
  }

  @override
  State<StatefulWidget> createState() {
    return _HomeScreen(company);
  }
}

class _HomeScreen extends State<HomeScreen> {
  String? curCompany;

  _HomeScreen(String? company){
    this.curCompany = company;
  }

  int _selectDrawerItem = 0;
  String _currentTitle = 'Nueva Operacion';
  List<String> _pageTitles = ['Nueva Operacion', 'Operaciones Registradas'];
  UserBloc userBloc = UserBloc();


  // _getDrawerItemWidget(int position) {
  //   switch(position) {
  //     case 0: return InstallationScreen();
  //     case 1: return InstallationCompletedListScreen();
  //   }
  // }

  //* Get current company and state
  _getCurrrentCompany(int position, String? company){
    if(position == 0){
      switch(company?.toUpperCase()){
        case "TRACKLINK": return InstallationScreen();
        case "TOYOTA": return InstallationScreenTY();
      }
    }

    if(position == 1){
      switch(company?.toUpperCase()){
        case "TRACKLINK": return InstallationCompletedListScreen();
        case "TOYOTA": return InstallationCompletedListScreenTY();
      }
    }


  }

  //* Get current app bar for company
  _getCurrentAppBar(String? company){
    switch(company?.toUpperCase()){
      case "TOYOTA": 
      return AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        title: Container(
          child: Row(
            children: [
              Text(_currentTitle, style: TextStyle(color: Colors.white),),
              // Padding(padding: EdgeInsets.only(left: 120.0)),
              Spacer(),
              Image.asset("assets/img/toyo.png", width: 50)
            ]),
        ), 
        backgroundColor: Color(0xFFD94753)
        // backgroundColor: Color(0xFFFFFFFF)
      );
      case "TRACKLINK": return AppBar(title: Text(_currentTitle), backgroundColor: Color(0xFF1D3043));
    }
  }

  _onSelectItem(int position) {
    Navigator.of(context).pop();
    setState(() {
      _currentTitle = _pageTitles[position];
      _selectDrawerItem = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);

    return StreamBuilder(
        stream: userBloc.userSelectedStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          User currentUser = snapshot.data;
          String userName = currentUser.name ?? "";
          String userFirstName = currentUser.firstName ?? "";
          String userLastName = currentUser.lastName ?? "";
          String userAvatar = userFirstName == "" ? "${userName[0]}${userName[1]}".toUpperCase() : "${userName[0]}${userFirstName[0]}".toUpperCase();



          return Scaffold(
            appBar: _getCurrentAppBar(this.curCompany),
            drawer: Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text('$userName'),
                    accountEmail: Text(currentUser.username),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Color(0xFF2362f5),
                      child: Text(userAvatar, style: TextStyle(fontSize: 30.0),),
                    ),
                  ),
                  ListTile(
                    title: Text('Nueva Operacion'),
                    leading: Icon(Icons.settings_input_antenna_outlined),
                    selected: (_selectDrawerItem == 0),
                    onTap: () {
                      _onSelectItem(0);
                    },
                  ),
                  ListTile(
                    title: Text('Operaciones Realizadas'),
                    leading: Icon(Icons.view_list),
                    selected: (_selectDrawerItem == 1),
                    onTap: () {
                      _onSelectItem(1);
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Salir', style: TextStyle(color: Colors.red)),
                    leading: Icon(Icons.exit_to_app, color: Colors.red),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => SignInScreen()), ModalRoute.withName('/login'));
                    },
                  ),
                ],
              ),
            ),
            body: _getCurrrentCompany(_selectDrawerItem, this.curCompany),
          );
        }
    );
  }
}
