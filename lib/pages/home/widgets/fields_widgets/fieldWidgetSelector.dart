import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/styles/brain_colors.dart';
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
          title: const Text('Tipos de Botones'),
        ),
        body: widget.bIsNumberField
            ? showNumberFieldSetup()
            : showTextFieldSetup());
  }

  // Muestra el widget de NumberField

  Widget showNumberFieldSetup() {
    return const Column(
      children: [Text('NumberField')],
    );
  }

  // Muestra el widget de TextField

  Widget showTextFieldSetup() {
    return const Column(
      children: [Text('TextField')],
    );
  }
}
