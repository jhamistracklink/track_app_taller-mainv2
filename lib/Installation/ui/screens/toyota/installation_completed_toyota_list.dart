import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:sai_track/Installation/bloc/bloc_installation.dart';
import 'package:sai_track/Installation/model/installation.dart';
import 'package:sai_track/widgets/button_blue.dart';
import 'package:intl/intl.dart';

class InstallationCompletedListScreenTY extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _InstallationCompletedListScreenState();
  }
}

class _InstallationCompletedListScreenState extends State<InstallationCompletedListScreenTY> {

  InstallationBloc installationBloc = InstallationBloc();
  String searchOrte = '';

  TextEditingController orteControler = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Installation>>(
      future: installationBloc.listInstallationTY(searchOrte),
      builder: (BuildContext context, AsyncSnapshot<List<Installation>> snapshot) {
        if (snapshot.hasError) {
          return Text("Ha ocurrido un error");
        } else if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {

          final installations = snapshot.data;

          return Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 10.0),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      controller: orteControler,
                      // keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'CBU - Chasis'),
                    )),
                    ButtonBlue(height: 30.0, width: 70.0, text: 'Buscar', onPressed: () async {
                      setState(() {
                        searchOrte = orteControler.text;
                      });
                    })
                  ],
                ),
              ),
              if (installations!.length == 0)
                Container(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.speaker_notes_off, size: 40, color: Colors.grey),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                        child: Text(
                          '0 registros de instalacion',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              Expanded(child: ListView.builder(
                itemCount: installations.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 6.0, top: 2.0),
                        child: _buildAuctionItem(installations[i]),
                      ),
                      Divider(thickness: 0.5, color: Colors.black54, height: 0),
                    ],
                  );
                },
              ))
            ],
          );
        }
      },
    );
  }

  Widget _buildAuctionItem(Installation installation) {

    final estadoInstalacion = installation.estado ?? "";
    final fechaInstalacion = installation.fechaCreacion ?? "";
    final fechaCreacion = DateTime.parse(fechaInstalacion);
    String formattedDate = DateFormat("dd/MM/yyyy HH:mm:ss").format(fechaCreacion);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      title: Text(
        "[Orte: " + installation.numeroOrte + "] " + installation.clienteNombres,
        style: TextStyle(
            fontSize: 16.0,
            color: Colors.black54,
            fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(formattedDate),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(installation.plan, style: TextStyle(fontSize: 11.0)),
                      ),
                      Badge(
                        backgroundColor: estadoInstalacion == 'INSTALADO' ? Colors.green : Colors.orange,
                        // shape: BadgeShape.square,
                        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                        // borderRadius: BorderRadius.circular(3),
                        // toAnimate: false,
                        child: Text(estadoInstalacion, style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
                Text('SP', style: TextStyle(color: Colors.transparent)),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(child: Icon(Icons.local_taxi, size: 18)),
                        TextSpan(
                            text: installation.placa + " / " +installation.chasis,
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
