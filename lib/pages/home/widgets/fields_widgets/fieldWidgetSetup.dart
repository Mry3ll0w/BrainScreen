import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/pages/models/field_widget_model.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:flutter/material.dart';

class Fieldwidgetsetup extends StatefulWidget {
  final String sProjectName;
  const Fieldwidgetsetup(
      {super.key, required projectName, required isNumberField})
      : sProjectName = projectName;

  @override
  State<Fieldwidgetsetup> createState() => _FieldwidgetsetupState();
}

class _FieldwidgetsetupState extends State<Fieldwidgetsetup> {
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

  @override
  void initState() {
    super.initState();
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
                              sTextDefaultValue = value;
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
                        labelText: sLabelText,
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
                              sLabelText = value;
                            })
                          },
                      decoration: InputDecoration(
                        hintText: 'LabelText',
                        errorText: sLabelText.isEmpty
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
                  child: TextField(
                      onChanged: (value) => {
                            setState(() {
                              sHelperText = value;
                            })
                          },
                      decoration: InputDecoration(
                        hintText: 'Texto de Ayuda',
                        errorText: sHelperText.isEmpty
                            ? 'El texto de ayuda no puede estar vacio'
                            : null,
                        helperText:
                            'Texto de ayuda colocado en la zona inferior',
                      )),
                )
              ])),
          Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: TextField(
                      onChanged: (value) => {
                            setState(() {
                              sErrorText = value;
                            })
                          },
                      decoration: InputDecoration(
                        hintText: 'Texto de error',
                        errorText: sHelperText.isEmpty
                            ? 'El texto de error no puede estar vacio'
                            : null,
                        helperText:
                            'Texto de error mostrado en caso de recibirse un error',
                      )),
                )
              ])),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: TextField(
                      onChanged: (value) => {
                            setState(() {
                              sPlaceHolder = value;
                            })
                          },
                      decoration: InputDecoration(
                          hintText: 'Valor mostrado de forma predeterminada',
                          helperText:
                              'Texto de error mostrado en caso de recibirse un error',
                          errorText: (bIsNumberField &&
                                  null == double.tryParse(sPlaceHolder))
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
                    value: bIsNumberField,
                    onChanged: (value) => {
                          setState(() {
                            bIsNumberField = value;
                          })
                        })
              ])),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
                child: ElevatedButton(
              onPressed: () async {
                try {
                  if (!(bIsNumberField &&
                      null == double.tryParse(sPlaceHolder))) {
                    WidgetController.addFieldWidgetToLienzo(
                        widget.sProjectName,
                        FieldWidgetModel(
                            labelText: sLabelText,
                            baseURL:
                                'http://192.168.1.160:3000', // SE DEJA ASI YA QUE EL USUARIO NO TIENE PQ EDITARLO
                            apiURL: '/FieldWidget',
                            widgetValue: "0",
                            numberField: bIsNumberField));
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  } else {
                    throw Exception('Error de creado de elementos');
                  }
                } catch (error) {
                  _creationError();
                }
              },
              child: const Text('Crear Widget'),
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
}
