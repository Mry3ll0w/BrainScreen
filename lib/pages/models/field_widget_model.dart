import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:brainscreen/pages/controllers/general_functions.dart';
import 'package:brainscreen/pages/controllers/http_controller.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FieldWidgetModel {
  String labelText_, baseURL_, apiURL_, widgetValue_;
  String? label;
  bool bIsNumberField_;

  // Constructor predeterminado, inicializamos los elementos minimos de los widgets
  FieldWidgetModel(
      {required String labelText,
      required String baseURL,
      required String apiURL,
      required String widgetValue,
      required bool numberField,
      String? label})
      : labelText_ = labelText,
        baseURL_ = baseURL,
        apiURL_ = apiURL,
        widgetValue_ = widgetValue,
        bIsNumberField_ = numberField;

  // Now we generate all the getters and setters.

  // Getters

  String get labelText => labelText_;
  String get baseURL => baseURL_;
  String get apiURL => apiURL_;
  String get widgetValue => widgetValue_;
  bool get isNumberField => bIsNumberField_;

  // Setters

  set labelText(String value) => labelText_ = value;
  set baseURL(String value) => baseURL_ = value;
  set apiURL(String value) => apiURL_ = value;
  set widgetValue(String value) => widgetValue_ = value;
  set isNumberField(bool value) => bIsNumberField_ = value;
}

/// Vista del modelo
class FieldWidgetView extends StatefulWidget {
  FieldWidgetView(
      {super.key,
      required FieldWidgetModel fieldwidget,
      required String sprojectName,
      required int pos})
      : fw = fieldwidget,
        projectName = sprojectName,
        iPos = pos;

  FieldWidgetModel fw;
  String projectName;
  int iPos;
  @override
  State<FieldWidgetView> createState() => _FieldWidgetViewState();
}

class _FieldWidgetViewState extends State<FieldWidgetView> {
  // Handler para cambios de valor en base de datos
  late StreamSubscription _subscriptionFwDataChanges;

  @override
  void initState() {
    super.initState();

    // Inicializamos event handler
    setupvalueChangerListener(widget.projectName, widget.fw, widget.iPos);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: TextField(
            enabled: true,
            onChanged: (value) => {
                  setState(() {
                    widget.fw.widgetValue = value;
                  })
                },
            style: const TextStyle(fontStyle: FontStyle.italic),
            decoration: InputDecoration(
              errorText: widget.fw.bIsNumberField_ &&
                      double.tryParse(widget.fw.widgetValue) == null
                  ? 'El valor debe ser numerado'
                  : null,
              suffixIcon: IconButton(
                color: Colors.purple,
                icon: const Icon(Icons.send),
                onPressed: () async {
                  // Send the notification
                  await fieldWidgetUpdateValue(
                      widget.fw.widgetValue, widget.projectName, widget.iPos);
                },
              ),
              fillColor: BrainColors.backgroundColor,
              filled: true,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2.0), // Color del borde cuando está habilitado
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: BrainColors.mainBannerColor,
                    width: 2.0), // Color del borde cuando está enfocado
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              labelText: widget.fw.labelText_,
            )),
      ),
    );
  }

  //Data Update onChange
  void setupvalueChangerListener(
      String projectName, FieldWidgetModel fw, int iPos) {
    // Pillamos El fieldWidget a controlar
    final databaseReference = FirebaseDatabase.instance
        .ref('/lienzo/$projectName/fieldWidgets/$iPos');

    _subscriptionFwDataChanges =
        databaseReference.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      debugPrint(snapshot.value.toString());
      try {
        dynamic data = snapshot.value;
        setState(() {
          widget.fw.widgetValue = data['value'].toString();
          widget.fw.labelText = data['labelText'].toString();
        });
        // ...
      } catch (e) {
        debugPrint('Error con data \n $e');
      }
    });
  }

  //PostCall for the Widget

  Future<void> fieldWidgetUpdateValue(
      dynamic newValue, String projectName, int index) async {
    //
    try {
      // Updateamos el valor en BBDD
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("lienzo/$projectName/buttons/$index");
      await ref.update({'value': newValue.toString()});

      // POST despues de actualizar el valor, test only
      await HttpRequestsController.put(
              widget.fw.baseURL,
              widget.fw.apiURL_,
              {"fwUpdated": index.toString()},
              GeneralFunctions.getLoggedUserUID(),
              '')
          .timeout(const Duration(seconds: 2));
    } on TimeoutException {
      _petitionErrorNotification(500, widget.fw.labelText, true);
    } catch (e) {
      debugPrint('ERROR en POST: $e');
      _petitionErrorNotification(500, widget.fw.labelText, false);
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
