import 'dart:convert' as convert;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Gestiona las peticiones HTTP que realizan los widgets
class HttpRequestsController {
  static String baseUrl_ = 'http://192.168.1.131:3000';
  static var client_ = http.Client();

  static Future<void> sendPostRequest(String title, String body, String url,
      String firebaseUID, String amazonUID) async {
    final apiUrl = Uri.parse(url);
    var response = await http.post(
      apiUrl,
      headers: {"Content-Type": "application/json"},
      body: convert.jsonEncode({
        "title": title,
        "body": body,
        "firebaseUID": firebaseUID,
        "amazonUID": amazonUID
      }),
    );

    if (response.statusCode == 201) {
      print("Post creado exitosamente!");
    } else {
      debugPrint('Respuesta: ' + response.request.toString());
    }
  }

  static Future<dynamic> get(String serverUrl, String api, String fieldValue,
      String firebaseAuth, String amazonAuth) async {
    var url = Uri.parse(serverUrl + api);

    var response = await client_.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint(jsonResponse[fieldValue]);
      return jsonResponse[fieldValue];
    } else {
      //throw exception and catch it in UI
    }
  }
}
