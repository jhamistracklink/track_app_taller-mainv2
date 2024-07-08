import 'dart:convert';

import 'package:sai_track/Installation/model/installation.dart';
import 'package:sai_track/globals.dart' as globals;
import 'package:http/http.dart' as http;

class InstallationRepository {
  Future<Installation> getInstallation(String numeroOrte, int? userId) async {
    var response = await http.get(
      Uri.parse(globals.baseApiUrl + '/operation/' + numeroOrte + '?idTecnico=' + userId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Basic ' + base64Encode(utf8.encode('${globals.apiUser}:${globals.apiPass}')),
      },
    );

    if (response.statusCode == 200) {
      String stringResponse = utf8.decode(response.bodyBytes);
      return Installation.fromMap(jsonDecode(stringResponse));
    } else {
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      print(data);
      throw Exception(data['error']);
    }
  }

  Future<Installation> getInstallationByChasisTY(String chasis, int? userId) async{
    var response = await http.get(
      Uri.parse(globals.baseApiUrl + '/operation/toyota/' + chasis + '?idTecnico=' + userId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Basic ' + base64Encode(utf8.encode('${globals.apiUser}:${globals.apiPass}')),
      },
    );

    if (response.statusCode == 200) {
      String stringResponse = utf8.decode(response.bodyBytes);
      return Installation.fromMap(jsonDecode(stringResponse));
    } else {
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      print(data);
      throw Exception(data['error']);
    }
  }

  Future<List<Installation>> listInstallation(String numeroOrte) async {
    var response = await http.get(
      Uri.parse(globals.baseApiUrl + '/operation/completados?orte=' + numeroOrte),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Basic ' + base64Encode(utf8.encode('${globals.apiUser}:${globals.apiPass}')),
      },
    );

    if (response.statusCode == 200) {
      String stringResponse = utf8.decode(response.bodyBytes);

      final List<Installation> list = [];
      for (Map map in jsonDecode(stringResponse)) {
        list.add(Installation.fromMap(map));
      }

      return list;
    } else {
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      print(data);
      throw Exception(data['error']);
    }
  }

  Future<List<Installation>> listInstallationTY(String value) async {
    var response = await http.get(
      Uri.parse(globals.baseApiUrl + '/operation/toyota/completados?value=' + value),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Basic ' + base64Encode(utf8.encode('${globals.apiUser}:${globals.apiPass}')),
      },
    );

    if (response.statusCode == 200) {
      String stringResponse = utf8.decode(response.bodyBytes);

      final List<Installation> list = [];
      for (Map map in jsonDecode(stringResponse)) {
        list.add(Installation.fromMap(map));
      }

      return list;
    } else {
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      print(data);
      throw Exception(data['error']);
    }
  }

  Future<Installation> saveInstallation(Installation payload) async {
    print(payload);
    var response = await http.post(
      Uri.parse(globals.baseApiUrl + '/operationCompleted/save'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Basic ' + base64Encode(utf8.encode('${globals.apiUser}:${globals.apiPass}')),
      },
      body: jsonEncode(payload.toJson()),
    );

    print("response.statusCode: ");
    print(response.statusCode);

    if (response.statusCode == 200) {
      String stringResponse = utf8.decode(response.bodyBytes);
      return Installation.fromMap(jsonDecode(stringResponse));
    } else {
      print("ERROR-- >");
      print(response.body);
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      print(data);
      throw Exception(data['error']);
    }
  }

  Future<String> getGprsAlert(String? unitId, String type) async {
    var response = await http.get(
      Uri.parse(globals.baseApiUrl + '/gprscommand/$unitId?type=$type'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Basic ' + base64Encode(utf8.encode('${globals.apiUser}:${globals.apiPass}')),
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      print(data);
      throw Exception(data['error']);
    }
  }

  Future<String> getSim(String imei) async {
    var response = await http.get(
      Uri.parse(globals.baseApiUrl + '/sim/$imei'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Basic ' + base64Encode(utf8.encode('${globals.apiUser}:${globals.apiPass}')),
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      return data['idsim'];
    } else {
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      print(data);
      throw Exception(data['error']);
    }
  }

  Future<String> sendPollComand(String? unitId, String type, String odometro) async {
    var response = await http.get(
      Uri.parse(globals.baseApiUrl + '/pollcammand/$unitId?type=$type&odometro=$odometro'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Basic ' + base64Encode(utf8.encode('${globals.apiUser}:${globals.apiPass}')),
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      print(data);
      throw Exception(data['error']);
    }
  }

  Future<String> getInfoIfExistsVinculacion(String? chasis) async{
    var response = await http.get(
      Uri.parse(globals.baseApiUrl + '/operation/toyota/validate/$chasis'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Basic ' + base64Encode(utf8.encode('${globals.apiUser}:${globals.apiPass}')),
      },
    );

    if (response.statusCode == 200) {
      return "true";
    } else {
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      print(data);
      throw Exception(data['error']);
    }
  }
}
