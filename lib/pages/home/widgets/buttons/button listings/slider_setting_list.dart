import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/widgets/buttons/editors/slider_editor_view.dart';

import 'package:brainscreen/pages/models/slider_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SliderSettingsList extends StatefulWidget {
  String _projectName = "";
  var selectedButton;
  final user = FirebaseAuth.instance.currentUser;
  SliderSettingsList({required super.key, required String sProjectName}) {
    _projectName = sProjectName;
  }

  @override
  State<SliderSettingsList> createState() => _SliderSettingsListState();
}

class _SliderSettingsListState extends State<SliderSettingsList> {
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
    List<CustomSliderModel> lCustomSliderModels =
        await WidgetController.fetchAllSlidersFromProject(widget._projectName);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Ajustes de botones'),
        ),
        body: _buildListTiles(lCustomSliderModels));
  }

  Widget _buildListTiles(List<CustomSliderModel> aSliders) {
    List<Widget> lTiles = [];

    for (var s in aSliders) {
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
                leading: _iconSelector(aSliders[index].type),
                title: Text(aSliders[index].labelText),
                subtitle: Text(_buttonTypeString(aSliders[index].type)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SliderSettingsEdit(
                              key: widget.key,
                              btn: aSliders[index],
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
