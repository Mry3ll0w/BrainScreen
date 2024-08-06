import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/models/button_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ButtonSettingsEdit extends StatefulWidget {
  String _projectName = "";
  ElevatedButtonModel? selectedButton;
  final user = FirebaseAuth.instance.currentUser;
  ButtonSettingsEdit(
      {required super.key,
      required String sProjectName,
      required ElevatedButtonModel btn}) {
    _projectName = sProjectName;
    selectedButton = btn;
  }

  @override
  State<ButtonSettingsEdit> createState() => _ButtonSettingsEditState();
}

class _ButtonSettingsEditState extends State<ButtonSettingsEdit> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadAllButtonsData(widget._projectName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Mostrar un indicador de carga mientras se espera
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Text(
              'Error al cargar los datos'); // Manejar el caso de error o datos nulos
        } else {
          return snapshot
              .data!; // Asignar directamente snapshot.data ya que hemos verificado que no es null
        }
      },
    );
  }

  Future<Widget> _loadAllButtonsData(String projectName) async {
    List<ElevatedButtonModel> lElevatedButtons =
        await WidgetController.fetchElevatedButtonsModels(projectName);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Parámetros del botón'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      label: Text(widget.selectedButton!.labelText_)),
                  onChanged: (value) {
                    setState(() {
                      widget.selectedButton?.labelText_ = value;
                    });
                  },
                ),
              )
            ],
          )),
        ));
  }
}
