import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
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

  ElevatedButton buildElevatedButtonWidget(
      String projectName, String buttonLabel) {
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
                _petitionErrorNotification(
                    responseStatus, projectName, buttonLabel, false);
              }
            } on TimeoutException {
              debugPrint("Excepcion tiempo");
              _petitionErrorNotification(500, projectName, buttonLabel, true);
            } catch (e) {
              debugPrint(e.toString());
              _petitionErrorNotification(500, projectName, buttonLabel, false);
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
                _petitionErrorNotification(
                    responseStatus, projectName, buttonLabel, false);
              }
            } on TimeoutException {
              debugPrint("Excepcion tiempo");
              _petitionErrorNotification(500, projectName, buttonLabel, true);
            } catch (e) {
              debugPrint(e.toString());
              _petitionErrorNotification(500, projectName, buttonLabel, false);
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
                _petitionErrorNotification(
                    responseStatus, projectName, buttonLabel, false);
              }
            } on TimeoutException {
              debugPrint("Excepcion tiempo");
              _petitionErrorNotification(500, projectName, buttonLabel, true);
            } catch (e) {
              debugPrint(e.toString());
              _petitionErrorNotification(500, projectName, buttonLabel, false);
            }
          },
        );
    }
  }

  void _petitionErrorNotification(int errorCode, String projectName,
      String buttonLabel, bool isTimeException) {
    if (!isTimeException && errorCode == 500) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'error_channel',
              title: 'Error durante la peticion del botón',
              body:
                  'En el proyecto $projectName al pulsar el boton con el label $buttonLabel se ha producido un error desconocido. '));
    } else if (isTimeException) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'error_channel',
              title: 'Error durante la peticion del botón',
              body:
                  'En el proyecto $projectName al pulsar el boton con el label $buttonLabel se ha tardado demasiado tiempo de respuesta, consulta el estado del servidor '));
    } else {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'error_channel',
              title: 'Error durante la peticion del botón',
              body:
                  'En el proyecto $projectName al pulsar el boton con el label $buttonLabel se ha recibido el codigo HTTP: $errorCode '));
    }
  }
}
