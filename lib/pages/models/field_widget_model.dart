import 'dart:async';

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
            enabled: false,
            onChanged: (value) => {
                  setState(() {
                    widget.fw.widgetValue = value;
                  })
                },
            style: const TextStyle(fontStyle: FontStyle.italic),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                color: Colors.purple,
                icon: const Icon(Icons.send),
                onPressed: () => {},
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

      setState(() {
        // Actualizar los datos del widget con los nuevos valores recibidos
        // Por ejemplo:
        // _data = snapshot.value ?? {};

        // TODO PASAR LOS VALORES DEL LISTENER A DOC y de alli actuaizar los campos del widget.fw
      });
    });
  }
}
