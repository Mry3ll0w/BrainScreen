import 'package:brainscreen/pages/home/widgets/fields_widgets/fieldWidgetSetup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FieldWidgetSelector extends StatefulWidget {
  //Required Elements
  String? sProjectName;
  bool bIsNumberField;
  //Ctor de Clase para guardar project
  FieldWidgetSelector(
      {required this.sProjectName, required this.bIsNumberField, super.key}) {
    sProjectName = sProjectName;
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  State<FieldWidgetSelector> createState() => _FieldWidgetSelectorState();
}

class _FieldWidgetSelectorState extends State<FieldWidgetSelector> {
  @override
  Widget build(BuildContext context) {
    //Screen Size
    final ScreenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Configura tu Widget'),
        ),
        body: widget.bIsNumberField
            ? showNumberFieldSetup(widget.sProjectName)
            : showTextFieldSetup(widget.sProjectName));
  }

  // Muestra el widget de NumberField

  Widget showNumberFieldSetup(String? projectName) {
    return Fieldwidgetsetup(projectName: projectName, isNumberField: true);
  }

  // Muestra el widget de TextField

  Widget showTextFieldSetup(String? projectName) {
    return Fieldwidgetsetup(projectName: projectName, isNumberField: true);
  }
}
