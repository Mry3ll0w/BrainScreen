import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:brainscreen/pages/controllers/general_functions.dart';
import 'package:brainscreen/pages/controllers/http_controller.dart';
import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class CustomSlider extends StatefulWidget {
  final Function()? onLongPressed;
  final CustomSliderModel? sl;
  final String sProjectName;
  //Def Constructor
  const CustomSlider(
      {super.key, this.onLongPressed, this.sl, this.sProjectName = ''});

  const CustomSlider.slider(
      {required super.key,
      this.onLongPressed,
      required this.sl,
      required this.sProjectName});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _currentSliderValue = 20;

  @override
  void initState() {
    super.initState();
    //Si no es null implica
    if (widget.sl != null) {
      _currentSliderValue = widget.sl!.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen_size = MediaQuery.of(context).size;
    return GestureDetector(
      onLongPress: () {
        if (widget.onLongPressed != null) {
          widget.onLongPressed!();
        }
      },
      child: SliderTheme(
        data: SliderThemeData(
          thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: screen_size.width < 400 ? 8 : 12),
          trackHeight: screen_size.width < 400 ? 6 : 8,
        ),
        child: Slider(
          value: _currentSliderValue,
          max: 100,
          divisions: 10,
          label: _currentSliderValue.toString(),
          onChanged: (double value) async {
            var previousValue = widget.sl!.value;
            setState(() {
              _currentSliderValue = value;
            });
            var res = await _handleValueChange();
            if (res == null) {
              setState(() {
                _currentSliderValue =
                    previousValue; // Considerable mejora visual
              });
            }
          },
        ),
      ),
    );
  }

  //Handle changes

  // Updates the value in that Switch
  Future<bool> _SliderValueUpdate(
      String sProjectName, String field, dynamic newfieldValue) async {
    //Si esta vacio pasamos de hacer nada
    if (newfieldValue.isNotEmpty) {
      // Primero buscamos en el lienzo que toque
      var lElevatedButtons =
          await WidgetController.fetchAllElevatedButtons(sProjectName);

      int iPosBtn = 0;
      for (var rawButton in lElevatedButtons) {
        if (widget.sl!._label == rawButton['label']) {
          break;
        }
        iPosBtn++;
      }

      //Una vez obtenida la posicion del boton lo actualizamos.
      try {
        DatabaseReference ref = FirebaseDatabase.instance
            .ref("lienzo/$sProjectName/buttons/$iPosBtn");
        await ref.update({field: newfieldValue});
        return true;
      } catch (e) {
        // Print Dialog Error
        _petitionErrorNotification(500, widget.sl!._labelText, false);
        return false;
      }
    } else {
      return false;
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

  /// Gestiona las actualizaciones junto con el servidor
  Future<bool?> _handleValueChange() async {
    try {
      // POST
      dynamic res = await HttpRequestsController.post_with_response(
              widget.sl!._baseURL_POST,
              widget.sl!._apiURL_POST,
              widget.sl!.payload,
              GeneralFunctions.getLoggedUserUID(),
              '')
          .timeout(const Duration(seconds: 2));

      //Pillamos el resultado de la peticion
      //! RECUERDA AL USUARIO QUE TIENE QUE HACER LAS PETICIONES CON RES:
      bool newState = bool.parse(res['response']['res'].toString());
      //Actualizamos el valor de ese modelo.
      await _SliderValueUpdate(
          widget.sProjectName, 'value', newState.toString());

      return newState;
    } catch (e) {
      debugPrint('ERROR en POST: $e');
      _petitionErrorNotification(500, widget.sl!._labelText, false);
      return null;
    }
  }
}

// Modelo de clase

class CustomSliderModel {
  // Declaramos los atributos

  String _type = '', _position = '';
  String _label = '', _labelText = '', _baseURL_POST = '', _apiURL_POST = '';
  dynamic _payload = {};

  double value = 0.00;

  // Constructor
  CustomSliderModel(
      {required String type,
      required String position,
      required String label,
      required String labelText,
      required String baseurlPost,
      required String apiurlPost,
      required dynamic payload,
      required double dValue})
      : _type = type,
        _position = position,
        _label = label,
        _labelText = labelText,
        _baseURL_POST = baseurlPost,
        _apiURL_POST = apiurlPost,
        _payload = payload,
        value = dValue;

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
  Widget buildSliderWidget(key, String projectName) {
    return CustomSlider.slider(
      onLongPressed: () {},
      sl: this,
      sProjectName: projectName,
      key: key,
    );
  }
}
