import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:brainscreen/pages/controllers/general_functions.dart';
import 'package:brainscreen/pages/controllers/http_controller.dart';
import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:flutter/material.dart';

class SwitchButtonModel {
  // Declaramos los atributos

  String _type = '', _position = '';
  String _label = '',
      _labelText = '',
      _baseURL_GET = '',
      _baseURL_POST = '',
      _apiURL_POST = '',
      _apiURL_GET = '';
  dynamic _payload = {};

  bool value = true;

  // Constructor
  SwitchButtonModel(
      {required String type,
      required String position,
      required String label,
      required String labelText,
      required String baseurlGet,
      required String baseurlPost,
      required String apiurlGet,
      required String apiurlPost,
      required dynamic payload,
      required bool bvalue})
      : _type = type,
        _position = position,
        _label = label,
        _labelText = labelText,
        _baseURL_GET = baseurlGet,
        _baseURL_POST = baseurlPost,
        _apiURL_GET = apiurlGet,
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

  String get baseURLGET => _baseURL_GET;
  set baseURLGET(String value) => _baseURL_GET = value;

  String get baseURLPOST => _baseURL_POST;
  set baseURLPOST(String value) => _baseURL_POST = value;

  String get apiURLPOST => _apiURL_POST;
  set apiURLPOST(String value) => _apiURL_POST = value;

  String get apiURLGET => _apiURL_GET;
  set apiURLGET(String value) => _apiURL_GET = value;

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

class SwitchWidgetBlock extends StatefulWidget {
  SwitchButtonModel sw = SwitchButtonModel(
      type: 'type',
      position: 'position',
      label: 'label',
      labelText: 'labelText',
      baseurlGet: 'baseurlGet',
      baseurlPost: 'baseurlPost',
      apiurlGet: 'apiurlGet',
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
              try {
                var res = await _handleValueChange()
                    .timeout(const Duration(seconds: 2));
                setState(() {
                  widget.sw.value = v;
                });
              } catch (e) {
                debugPrint('ERROR en GET: $e');
                //TODO SHOW DIALOG ERROR
              }
            }),
        Text(widget.sw.labelText)
      ],
    );
  }

  /// Gestiona los cambios de valor en un switch
  Future<bool> _handleValueChange() async {
    try {
      var res = await HttpRequestsController.get(widget.sw.baseURLGET,
          widget.sw.apiURLGET, 'res', GeneralFunctions.getLoggedUserUID(), '');
      debugPrint(res);
      return true;
    } catch (e) {
      debugPrint("Error de lectura del valor del switch: $e");
    }

    return false;
  }
}
