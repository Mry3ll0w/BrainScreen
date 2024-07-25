import 'dart:convert' as convert;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Gestiona las peticiones HTTP que realizan los widgets
class HttpRequestsController {
  static var client_ = http.Client();

  /// Realiza una peticion de tipo get, pensado para los widgets.
  /// @param serverUrl: url del servidor original. (ej: google.es)
  /// @param api: Seccion del servidor a la que queremos hacer la peticion (ej: google.es/getData ==> /getData)
  /// @param fieldValue: Dato del cuerpo de la respuesta que nos interesa (ej: {data: 4}==> data)
  /// @param firebaseUID: uid del usuario de firebase
  /// @param amazonUID: uid de amazon.
  /// @return dynamic (valor del cuerpo de la respuesta deseado )
  static Future<dynamic> get(String serverUrl, String api, String fieldValue,
      String firebaseUID, String amazonUID) async {
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

  /// Realiza una peticion de tipo POST, pensado para los widgets.
  /// @param serverUrl: url del servidor original. (ej: google.es)
  /// @param api: Seccion del servidor a la que queremos hacer la peticion (ej: google.es/getData ==> /getData)
  /// @param object: Dato del cuerpo a enviar (ej: {"data": 4})
  /// @param firebaseUID: uid del usuario de firebase
  /// @param amazonUID: uid de amazon.
  /// @return int (status de la respuesta enviada)
  static Future<dynamic> post(String serverUrl, String api,
      Map<String, String> object, String firebaseUID, String amazonUID) async {
    try {
      var url = Uri.parse(serverUrl + api);
      var payload = convert.json.encode(object);
      var headers = {
        'Content-Type': 'application/json',
        'firebaseUID': firebaseUID,
        'amazonUID': amazonUID,
      };

      var response = await client_.post(url, body: payload, headers: headers);
      debugPrint(response.statusCode.toString());
      return response
          .statusCode; // Siempre devolvemos el status code, ya que el post no espera respuesta compleja si no confirmacion de la accion.
    } catch (e) {
      debugPrint('Exception $e');
    }
    return null;
  }

  // Realiza una peticion de tipo PUT, pensado para los widgets.
  /// @param serverUrl: url del servidor original. (ej: google.es)
  /// @param api: Seccion del servidor a la que queremos hacer la peticion (ej: google.es/getData ==> /getData)
  /// @param object: Dato del cuerpo a enviar (ej: {"data": 4})
  /// @param firebaseUID: uid del usuario de firebase
  /// @param amazonUID: uid de amazon.
  /// @return int (status de la respuesta enviada)
  static Future<dynamic> put(String serverUrl, String api,
      Map<String, String> object, String firebaseUID, String amazonUID) async {
    try {
      var url = Uri.parse(serverUrl + api);
      var payload = convert.json.encode(object);
      var headers = {
        'Content-Type': 'application/json',
        'firebaseUID': firebaseUID,
        'amazonUID': amazonUID,
      };
      debugPrint('Valor de payload: $payload');
      var response = await client_.put(url, body: payload, headers: headers);
      debugPrint(response.statusCode.toString());
      return response
          .statusCode; // Siempre devolvemos el status code, ya que el post no espera respuesta compleja si no confirmacion de la accion.
    } catch (e) {
      debugPrint('Exception $e');
    }
    return null;
  }
}
