import 'package:brainscreen/pages/controllers/general_functions.dart';
import 'package:brainscreen/pages/controllers/http_controller.dart';
import 'package:flutter/material.dart';

class ElevatedButtonModel {
  String label_ = '',
      labelText_ = '',
      petition_ = '',
      type_ = '',
      baseURL_ = '',
      apiURL_ = '';

  bool bIncomplete = false;

  Map<String, String> payload_ = {};

  ElevatedButtonModel(String label, String labelText, String type,
      String baseURL, String apiURL, Map<String, String> payload) {
    if (label.isEmpty ||
        labelText.isEmpty ||
        type.isEmpty ||
        baseURL.isEmpty ||
        apiURL.isEmpty) {
      bIncomplete = true;
    }
    label_ = label;
    labelText_ = labelText;
    type = type_;
    baseURL_ = baseURL;
    apiURL_ = apiURL;
    payload_ = payload;
  }

  /// Funcion para construir el elevatedButton, los parametros los recibe en el constructor de clase
  /// @return ElevatedButton

  ElevatedButton buildElevatedButtonWidget() {
    switch (petition_) {
      case 'POST':
        return ElevatedButton(
          child: Text(labelText_),
          onPressed: () async {
            var responseStatus = await HttpRequestsController.post(baseURL_,
                apiURL_, payload_, GeneralFunctions.getLoggedUserUID(), '');
          },
        );

      case 'PUT':
        return ElevatedButton(
          child: Text(labelText_),
          onPressed: () async {
            var responseStatus = await HttpRequestsController.put(baseURL_,
                apiURL_, payload_, GeneralFunctions.getLoggedUserUID(), '');
          },
        );
      default:
        return ElevatedButton(
          child: Text(labelText_),
          onPressed: () async {
            var responseStatus = await HttpRequestsController.post(baseURL_,
                apiURL_, payload_, GeneralFunctions.getLoggedUserUID(), '');
          },
        );
    }
  }
}
