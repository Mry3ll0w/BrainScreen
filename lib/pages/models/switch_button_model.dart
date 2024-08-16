import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:brainscreen/pages/controllers/general_functions.dart';
import 'package:brainscreen/pages/controllers/http_controller.dart';
import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:flutter/material.dart';

class SwitchButtonModel {
  // Declaramos los atributos

  String _type = '', _position = '';
  String _label = '', _labelText = '', _baseURL_POST = '', _apiURL_POST = '';
  dynamic _payload = {};

  bool value = true;

  // Constructor
  SwitchButtonModel(
      {required String type,
      required String position,
      required String label,
      required String labelText,
      required String baseurlPost,
      required String apiurlPost,
      required dynamic payload,
      required bool bvalue})
      : _type = type,
        _position = position,
        _label = label,
        _labelText = labelText,
        _baseURL_POST = baseurlPost,
        _apiURL_POST = apiurlPost,
        _payload = payload,
        value = bvalue;

  // Getters
  String get type => _type;
  set type(String value) => _type = value;

  String get position => _position;
  set position(String value) => _position = value;

  String get label => _label;
  set label(String value) => _label = value;

  String get labelText => _labelText;
  set labelText(String value) => _labelText = value;

  String get baseURLPOST => _baseURL_POST;
  set baseURLPOST(String value) => _baseURL_POST = value;

  String get apiURLPOST => _apiURL_POST;
  set apiURLPOST(String value) => _apiURL_POST = value;

  dynamic get payload => _payload;
  set payload(dynamic value) => _payload = value;

  // Método para manejar errores de petición
  void _petitionErrorNotification(
      int errorCode, String projectName, bool isTimeException) {
    // Implementación existente...
  }

  // Método para construir el widget
  Widget buildSwitchWidget(key) {
    return SwitchWidgetBlock(s: this);
  }
}

/// Model de Switch a enviar para hacerlo mas limpio
class SwitchWidgetBlock extends StatefulWidget {
  SwitchButtonModel sw = SwitchButtonModel(
      type: 'type',
      position: 'position',
      label: 'label',
      labelText: 'labelText',
      baseurlPost: 'baseurlPost',
      apiurlPost: 'apiurlPost',
      payload: 'payload',
      bvalue: true);
  SwitchWidgetBlock({super.key, required SwitchButtonModel s}) : sw = s;

  @override
  State<SwitchWidgetBlock> createState() => _SwitchWidgetBlockState();
}

class _SwitchWidgetBlockState extends State<SwitchWidgetBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Switch(
            value: widget.sw.value, // Usa el dato obtenido del Future
            onChanged: (v) async {
              //Aplicamos el cambio de valor
              var res = await _handleValueChange();
              if (res != null) {
                setState(() {
                  widget.sw.value = v;
                });
              }
            }),
        Text(widget.sw.labelText)
      ],
    );
  }

  /// Gestiona los cambios de valor en un switch

  Future<bool?> _handleValueChange() async {
    try {
      // POST
      //debugPrint('Resultado de GET: ${res.toString()}');
      return true;
    } on TimeoutException {
      _petitionErrorNotification(500, widget.sw._labelText, true);
      return null;
    } catch (e) {
      debugPrint('ERROR en GET: $e');
      _petitionErrorNotification(500, widget.sw._labelText, false);
      return null;
    }
  }

  /// Error de conexiones de switch
  void _petitionErrorNotification(
      int errorCode, String buttonLabel, bool isTimeException) {
    if (!isTimeException && errorCode == 500) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'error_channel',
              title: 'Error durante la peticion del Interruptor',
              body:
                  'Error al pulsar el interruptor con el label $buttonLabel se ha producido un error desconocido. '));
    } else if (isTimeException) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'error_channel',
              title: 'Error durante la peticion del Interruptor',
              body:
                  'Al pulsar el interruptor con el label $buttonLabel se ha tardado demasiado tiempo de respuesta, consulta el estado del servidor '));
    } else {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'error_channel',
              title: 'Error durante la peticion del Interruptor',
              body:
                  'Al pulsar el interruptor con el label $buttonLabel se ha recibido el codigo HTTP: $errorCode '));
    }
  }
}
