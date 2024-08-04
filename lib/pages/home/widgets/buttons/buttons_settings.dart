import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/models/button_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ButtonSettings extends StatefulWidget {
  String _projectName = "";
  var selectedButton;
  final user = FirebaseAuth.instance.currentUser;
  ButtonSettings({required super.key, required String sProjectName}) {
    _projectName = sProjectName;
  }

  @override
  State<ButtonSettings> createState() => _ButtonSettingsState();
}

class _ButtonSettingsState extends State<ButtonSettings> {
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
        title: const Text('Ajustes de botones'),
      ),
      body: Center(
        child: Row(children: _buildListTiles(lElevatedButtons)),
      ),
    );
  }

  // ! FIX ERROR TURBIO DE LAYOUT
  List<Widget> _buildListTiles(List<ElevatedButtonModel> aButtons) {
    List<Widget> lTiles = [];
    for (var b in aButtons) {
      lTiles.add(ListTile(
        leading: Icon(Icons.smart_button_outlined),
        title: Text(b.labelText_),
        subtitle: const Text("Botón"),
      ));
    }

    return lTiles;
  }
}
