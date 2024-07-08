import 'dart:convert';
import 'dart:io';

import 'package:sai_track/User/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:sai_track/globals.dart' as globals;

class UserRepository {
  Future<User> getUser(User user) async {
    var response = await http.post(
      Uri.parse(globals.baseApiUrl + '/usuario/access'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Basic ' + base64Encode(utf8.encode('${globals.apiUser}:${globals.apiPass}')),
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body));
    } else {
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      print(data);
      throw Exception(data['error']);
    }
  }
}
