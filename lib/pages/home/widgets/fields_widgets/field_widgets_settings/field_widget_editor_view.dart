import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/pages/models/field_widget_model.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FieldWidgetEditorView extends StatefulWidget {
  final String sProjectName;
  final int iIndex;
  const FieldWidgetEditorView(
      {super.key, required projectName, required int index})
      : sProjectName = projectName,
        iIndex = index;

  @override
  State<FieldWidgetEditorView> createState() => _FieldWidgetEditorViewState();
}

class _FieldWidgetEditorViewState extends State<FieldWidgetEditorView> {
  String h1 = 'Vista previa del Widget';

  //Variables de inicializacion del Widget a crear.
  String sTextDefaultValue = '',
      sErrorText = 'Soy un mensaje de error',
      sPlaceHolder = 'Soy un placeHolder',
      sLabelText = 'Soy un labelText',
      sHelperText = 'Mensaje de ayuda',
      sBaseURL = 'http://192.168.1.160:3000',
      sAPIURL = '/FieldWidget';
  String? prevErrorText;

  bool bTestError = false;
  bool showErrorText = false;

  bool bIsNumberField = false;

  FieldWidgetModel fw = FieldWidgetModel(
      labelText: '',
      baseURL: '',
      apiURL: '',
      widgetValue: '',
      numberField: false);

  late StreamSubscription _subscriptionFwDataChanges;
  @override
  void initState() {
    //Inicializamos el fw
    initializeFieldWidgetValues_(widget.sProjectName, widget.iIndex, fw);
    super.initState();
    //Listener de cambios
    setupvalueChangerListener(widget.sProjectName, fw, widget.iIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              h1,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Center(
              child: Column(
                children: [
                  TextField(
                      enabled: false,
                      onChanged: (value) => {
                            setState(() {
                              fw.widgetValue = value;
                            })
                          },
                      style: const TextStyle(fontStyle: FontStyle.italic),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          color: Colors.purple,
                          icon: const Icon(Icons.send),
                          onPressed: () => {},
                        ),
                        errorText: prevErrorText,
                        fillColor: BrainColors.backgroundColor,
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width:
                                  2.0), // Color del borde cuando está habilitado
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: BrainColors.mainBannerColor,
                              width:
                                  2.0), // Color del borde cuando está enfocado
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: fw.labelText,
                        helperText: sHelperText,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text('Mostrar mensaje de error'),
                        ),
                        Switch(
                            value: showErrorText,
                            onChanged: (value) => {
                                  setState(() {
                                    showErrorText = value;
                                    prevErrorText = value ? sErrorText : null;
                                  })
                                })
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: TextField(
                      onChanged: (value) => {
                            setState(() {
                              fw.labelText = value;
                            })
                          },
                      decoration: InputDecoration(
                        hintText: fw.labelText,
                        errorText: fw.labelText.isEmpty
                            ? 'El label text no puede estar vacio'
                            : null,
                        helperText: 'Placeholder del Widget',
                      )),
                )
              ])),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: TextFormField(
                      initialValue: fw.widgetValue.toString(),
                      onChanged: (value) => {
                            setState(() {
                              fw.widgetValue = value;
                            })
                          },
                      decoration: InputDecoration(
                          hintText: fw.widgetValue,
                          helperText:
                              'Texto de error mostrado en caso de recibirse un error',
                          errorText: (fw.bIsNumberField_ &&
                                  null == double.tryParse(fw.widgetValue))
                              ? 'Si es un numberfield el valor debe ser numerado'
                              : null)),
                ),
              ])),
          Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(children: [
                const Padding(
                  padding: EdgeInsets.only(right: 40.0),
                  child: Text('Es un NumberField'),
                ),
                Switch(
                    value: fw.bIsNumberField_,
                    onChanged: (value) => {
                          setState(() {
                            fw.bIsNumberField_ = value;
                          })
                        })
              ])),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
                child: ElevatedButton(
              onPressed: () async {
                try {
                  if (!(fw.bIsNumberField_ &&
                      null == double.tryParse(fw.widgetValue))) {
                    WidgetController.updateFieldWidgetByModelAndProjectName(
                        fw, widget.iIndex, widget.sProjectName);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  } else {
                    throw Exception('Error de creado de elementos');
                  }
                } catch (error) {
                  debugPrint(error.toString());
                  //_creationError();
                }
              },
              child: const Text('Editar Widget'),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Center(
                child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            )),
          )
        ],
      ),
    );
  }

  // Muestra notificacion de fallo al crear el TextField;
  /// Error de conexiones de switch
  void _creationError() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: 'error_channel',
            title: 'Error al agregar el FieldWidget',
            body:
                'Se ha producido un error al crear el fieldWidget intente hacerlo mas tarde.'));
  }

  // Inicializa el widget a recibir.
  Future<void> initializeFieldWidget(FieldWidgetModel fw, int index) async {}

  // Se deben respetar los cambios en la nube primero y despues cambiarlo.
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
          // Actualizar los campos
          fw.apiURL = data['apiurl'];
          fw.bIsNumberField_ = data['isNumberField'];
          fw.baseURL = data['baseurl'];
          fw.label = data['label'];
          fw.labelText_ = data['labelText'];
          fw.widgetValue = data['value'];
        });
        // ...
      } catch (e) {
        debugPrint('Error con data \n $e');
      }

      // Pasamos a lista dinamica
    });
  }

  Future<void> initializeFieldWidgetValues_(
      String projectName, int index, FieldWidgetModel fw) async {
    final databaseReference = FirebaseDatabase.instance
        .ref('/lienzo/$projectName/fieldWidgets/$index');
    final snapshot = await databaseReference.get();

    try {
      dynamic data = snapshot.value;
      setState(() {
        // Actualizar los campos
        fw.apiURL = data['apiurl'];
        fw.bIsNumberField_ = data['isNumberField'];
        fw.baseURL = data['baseurl'];
        fw.label = data['label'];
        fw.labelText_ = data['labelText'];
        fw.widgetValue = data['value'];
      });
      // ...
    } catch (e) {
      debugPrint('Error con data \n $e');
    }
  }
}
