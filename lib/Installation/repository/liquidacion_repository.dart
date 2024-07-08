import 'dart:convert';

import 'package:sai_track/Installation/model/liquidacion.dart';
import 'package:sai_track/globals.dart' as globals;
import 'package:http/http.dart' as http;

class LiquidacionRepository {

Future<String> getGpsCodeByImei(String imei) async{
  var response = await http.post(
      Uri.parse(globals.baseLiqApiUrl + '/searchDeviceByImei'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authToken': globals.liqAuthToken,
      },
      body: jsonEncode({"imei" : imei}),
    );

    print("response.statusCode: ");
    print("search data=======================================>");
    print(response.statusCode);

    if (response.statusCode == 200) {
      String stringResponse = utf8.decode(response.bodyBytes);
      var data = jsonDecode(stringResponse);
      print(data);
      return data['gpsCode'];
    } else {
      print("ERROR-- >");
      print(response.body);
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      throw Exception("No se pudo recuperar la data");
    }
}

Future<String> saveLiquidacion(Liquidacion payload) async {
  print("INIT REQUEST SAVE DATA=======================================>");
    print(payload);
    var response = await http.post(
      Uri.parse(globals.baseLiqApiUrl + '/saveLiquidacion'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authToken': globals.liqAuthToken,
      },
      body: jsonEncode(payload.toJson()),
    );

    print("response.statusCode: ");
    print("SAVE DATA=======================================>");
    print(response.statusCode);

    if (response.statusCode == 200) {
      print("========================================");
      print("LIQUIDACION GUARDADA EXITOSAMENTE");
      print("========================================");
      String stringResponse = utf8.decode(response.bodyBytes);
      print(stringResponse);
      return "Guardada";
    } else {
      print("ERROR-- >");
      print(response.body);
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      print(data);
      throw Exception(data['error']);
    }
  }
}