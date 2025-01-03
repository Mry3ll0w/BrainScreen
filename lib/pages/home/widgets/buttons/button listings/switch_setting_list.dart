import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/widgets/buttons/editors/switch_editor_view.dart';
import 'package:brainscreen/pages/models/switch_button_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SwitchSettingsList extends StatefulWidget {
  String _projectName = "";
  var selectedButton;
  final user = FirebaseAuth.instance.currentUser;
  SwitchSettingsList({required super.key, required String sProjectName}) {
    _projectName = sProjectName;
  }

  @override
  State<SwitchSettingsList> createState() => _SwitchSettingsListState();
}

class _SwitchSettingsListState extends State<SwitchSettingsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadAllSwitchesData(widget._projectName),
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
  Future<Widget> _loadAllSwitchesData(String projectName) async {
    List<SwitchButtonModel> lSwitchButtonModels =
        await WidgetController.fetchAllSwitchesFromProject(widget._projectName);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Ajustes de botones'),
        ),
        body: _buildListTiles(lSwitchButtonModels));
  }

  Widget _buildListTiles(List<SwitchButtonModel> aSwitches) {
    List<Widget> lTiles = [];

    // Cargamos la lista de switches
    for (var s in aSwitches) {
      // Preparamos La lista de Filas
      lTiles.add(ListTile(
        leading: const Row(
          children: [
            Icon(Icons.light_mode),
            Text(
              '/',
              style: TextStyle(fontSize: 20),
            ),
            Icon(Icons.light_mode_outlined)
          ],
        ),
        title: Text(s.labelText),
        subtitle: const Text("Interruptor"),
      ));
      // Parseamos de Switch a button
    }

    return Container(
        margin: const EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: lTiles.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: _iconSelector(aSwitches[index].type),
                title: Text(aSwitches[index].labelText),
                subtitle: Text(_buttonTypeString(aSwitches[index].type)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SwitchSettingsEdit(
                              key: widget.key,
                              btn: aSwitches[index],
                              sProjectName: widget._projectName)));
                },
              );
            }));
  }

  String _buttonTypeString(String type) {
    switch (type) {
      case '0':
        return 'Btn. Unidireccional';
      case '1':
        return 'Btn. Switch';
      case '2':
        return 'Slider';
      default:
        return 'Btn.';
    }
  }

  Widget _iconSelector(String type) {
    if (type == '0') {
      return const Icon(Icons.bolt);
    } else if (type == '1') {
      return const Icon(Icons.light_mode);
    } else {
      return const Icon(Icons.commit);
    }
  }

  Widget _editorSelector(String btnType) {
    return Container();
  }
}
