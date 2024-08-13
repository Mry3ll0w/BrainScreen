import 'dart:ffi';

class SwitchButtonModel {
  // Declaramos los atributos

  /*
     "label": randomLabelGenerator(6),
            "type": "1",
            "labelText": "Switch",
            "position": "0",
            "baseurl_get": dotenv.env['TESTING_SERVER_URL'],
            "baseurl_post": dotenv.env['TESTING_SERVER_URL'],
            "apiurl_post": "/test",
            "apiurl_get": "/",
            "payload": {"dato": "valor"}
  */

  int _type = 1, _position = 0;
  String _label = '',
      _labelText = '',
      _baseURL_GET = '',
      _baseURL_POST = '',
      _apiURL_POST = '',
      _apiURL_GET = '';
  Map<String, String> _payload = {};

  SwitchButtonModel(
      {required int type,
      required int position,
      required String label,
      required String labelText,
      required String baseurlGet,
      required String baseurlPost,
      required String apiurlGet,
      required String apiurlPost,
      required Map<String, String> payload}) {
    _type = type;
    _position = position;
    _label = label;
    _labelText = labelText;
    _baseURL_GET = baseurlGet;
    _baseURL_POST = baseurlPost;
    _apiURL_GET = apiurlGet;
    _apiURL_POST = apiurlPost;
    _payload = payload;
  }
}
