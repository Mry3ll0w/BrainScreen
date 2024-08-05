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

  /// Inicializa el widget como Future y carga los elementos de los botones
  Future<Widget> _loadAllButtonsData(String projectName) async {
    List<ElevatedButtonModel> lElevatedButtons =
        await WidgetController.fetchElevatedButtonsModels(projectName);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Parámetros del botón'),
        ),
        body: _buildListTiles(lElevatedButtons));
  }

  // ! FIX ERROR TURBIO DE LAYOUT
  Widget _buildListTiles(List<ElevatedButtonModel> aButtons) {
    List<Widget> lTiles = [];
    for (var b in aButtons) {
      lTiles.add(ListTile(
        leading: Icon(Icons.smart_button_outlined),
        title: Text(b.labelText_),
        subtitle: const Text("Botón"),
      ));
    }

    return Container(
        margin: const EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: lTiles.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.bolt),
                title: Text(aButtons[index].labelText_),
                subtitle: Text(_buttonTypeString(aButtons[index].type_)),
                onTap: () {},
              );
            }));
  }

  String _buttonTypeString(String type) {
    switch (type) {
      case '0':
        return 'Btn. Unidireccional';
      case '1':
        return 'Btn. Switch';
      default:
        return 'Btn.';
    }
  }
}
