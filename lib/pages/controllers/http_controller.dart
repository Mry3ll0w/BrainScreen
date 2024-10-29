import 'dart:convert' as convert;
import 'dart:async';
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
  static Future<dynamic> post(String serverUrl, String api, dynamic object,
      String firebaseUID, String amazonUID) async {
    var url = Uri.parse(serverUrl + api);
    var payload = convert.json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
      'firebaseUID': firebaseUID,
      'amazonUID': amazonUID,
    };

    var response = await client_.post(url, body: payload, headers: headers);

    return response
        .statusCode; // Siempre devolvemos el status code, ya que el post no espera respuesta compleja si no confirmacion de la accion.
  }

  /// Realiza una peticion de tipo POST y reciba la respuesta, pensado para los widgets.
  /// @param serverUrl: url del servidor original. (ej: google.es)
  /// @param api: Seccion del servidor a la que queremos hacer la peticion (ej: google.es/getData ==> /getData)
  /// @param object: Dato del cuerpo a enviar (ej: {"data": 4})
  /// @param firebaseUID: uid del usuario de firebase
  /// @param amazonUID: uid de amazon.
  /// @return {status: int, response: dynamic}
  static Future<dynamic> post_with_response(String serverUrl, String api,
      dynamic object, String firebaseUID, String amazonUID) async {
    var url = Uri.parse(serverUrl + api);

    var payload = convert.json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
      'firebaseUID': firebaseUID,
      'amazonUID': amazonUID,
    };
    var response = await client_.post(url, body: payload, headers: headers);

    // Decode the JSON string to a Map<dynamic, dynamic>
    Map<dynamic, dynamic> tempMap = convert.jsonDecode(response.body);

    // Cast the Map<dynamic, dynamic> to Map<String, String>
    Map<String, String> resultMap = tempMap.cast<String, String>();

    // Pasamos el cuerpo respondido a json
    var fullResponse = {
      'status': response.statusCode.toString(),
      'response': resultMap
    };
    return fullResponse; // Siempre devolvemos el status code, ya que el post no espera respuesta compleja si no confirmacion de la accion.
  }

  // Realiza una peticion de tipo PUT, pensado para los widgets.
  /// @param serverUrl: url del servidor original. (ej: google.es)
  /// @param api: Seccion del servidor a la que queremos hacer la peticion (ej: google.es/getData ==> /getData)
  /// @param object: Dato del cuerpo a enviar (ej: {"data": 4})
  /// @param firebaseUID: uid del usuario de firebase
  /// @param amazonUID: uid de amazon.
  /// @return int (status de la respuesta enviada)
  static Future<dynamic> put(String serverUrl, String api, dynamic object,
      String firebaseUID, String amazonUID) async {
    var url = Uri.parse(serverUrl + api);
    var payload = convert.json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
      'firebaseUID': firebaseUID,
      'amazonUID': amazonUID,
    };
    var response = await client_.put(url, body: payload, headers: headers);
    return response
        .statusCode; // Siempre devolvemos el status code, ya que el post no espera respuesta compleja si no confirmacion de la accion.

    /** Ejemplo de como realizar llamadas a la funcion
    HttpRequestsController.put(
                    dotenv.env['TESTING_SERVER_URL']!,
                    '/test',
                    {'data': 'Hola desde flutter'},
                    GeneralFunctions.getLoggedUserUID(),
                    '');
     */
  }
}
