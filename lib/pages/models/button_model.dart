import 'dart:async';

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

  dynamic payload_ = {};

  ElevatedButtonModel({
    required String label,
    required String labelText,
    required String type,
    required String petition,
    required String baseURL,
    required String apiURL,
    required dynamic
        payload, // 'required' indica que el parámetro debe ser proporcionado
  }) {
    if (label.isEmpty ||
        labelText.isEmpty ||
        type.isEmpty ||
        baseURL.isEmpty ||
        apiURL.isEmpty) {
      bIncomplete = true;
    }
    label_ = label;
    labelText_ = labelText;
    type_ = type;
    baseURL_ = baseURL;
    apiURL_ = apiURL;
    payload_ = payload;
    petition_ = petition;
  }

  /// Funcion para construir el elevatedButton, los parametros los recibe en el constructor de clase
  /// @return ElevatedButton

  ElevatedButton buildElevatedButtonWidget() {
    switch (petition_) {
      case 'POST':
        return ElevatedButton(
          child: Text(labelText_),
          onPressed: () async {
            try {
              var responseStatus = await HttpRequestsController.post(
                      baseURL_,
                      apiURL_,
                      payload_,
                      GeneralFunctions.getLoggedUserUID(),
                      '')
                  .timeout(const Duration(seconds: 3));
              if (responseStatus != 200) {
                //TODO Gestionar notificaciones
              }
            } on TimeoutException {
              debugPrint("Excepcion tiempo");
            } catch (e) {
              debugPrint(e.toString());
            }
          },
        );

      case 'PUT':
        return ElevatedButton(
          child: Text(labelText_),
          onPressed: () async {
            try {
              var responseStatus = await HttpRequestsController.put(
                      baseURL_,
                      apiURL_,
                      payload_,
                      GeneralFunctions.getLoggedUserUID(),
                      '')
                  .timeout(const Duration(seconds: 3));
              if (responseStatus != 200) {
                //TODO Gestionar notificaciones
              }
            } on TimeoutException {
              debugPrint("Excepcion tiempo");
            } catch (e) {
              debugPrint(e.toString());
            }
          },
        );
      default:
        return ElevatedButton(
          child: Text(labelText_),
          onPressed: () async {
            try {
              var responseStatus = await HttpRequestsController.post(
                      baseURL_,
                      apiURL_,
                      payload_,
                      GeneralFunctions.getLoggedUserUID(),
                      '')
                  .timeout(const Duration(seconds: 3));
              if (responseStatus != 200) {
                //TODO Gestionar notificaciones
              }
            } on TimeoutException {
              debugPrint("Excepcion tiempo");
            } catch (e) {
              debugPrint(e.toString());
            }
          },
        );
    }
  }
}
