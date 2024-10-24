import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/widgets/fields_widgets/field_widgets_settings/field_widget_editor_view.dart';
import 'package:flutter/material.dart';

class FieldWidgetsListingView extends StatelessWidget {
  const FieldWidgetsListingView(
      {super.key, required String sprojectName, required bool bIsNumberField})
      : isNumberField = bIsNumberField,
        projectName = sprojectName;
  final String projectName;
  final bool isNumberField;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadAllFwTiles(projectName, isNumberField),
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
  Future<Widget> _loadAllFwTiles(
      String projectName, bool bIsNumberField) async {
    List<dynamic> lFieldWidgets =
        await WidgetController.fetchAllFieldWidgetsRAW(
            projectName, bIsNumberField);

    return Scaffold(
        appBar: AppBar(
          title: isNumberField
              ? const Text('Lista de Numberfields')
              : const Text('Lista de TextField'),
        ),
        body: _buildListTiles(lFieldWidgets, projectName));
  }

  Widget _buildListTiles(List<dynamic> lFieldWidgets, String sProjectName) {
    List<Widget> lTiles = [];

    for (var fw in lFieldWidgets) {
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
        title: Text(fw['labelText']),
        subtitle:
            isNumberField ? const Text('Numberfield') : const Text('TextField'),
      ));
      // Parseamos de Switch a button
    }

    return Container(
        margin: const EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: lTiles.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: isNumberField
                    ? const Icon(Icons.twenty_four_mp)
                    : const Icon(Icons.translate),
                title: Text(lFieldWidgets[index]['labelText']),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FieldWidgetEditorView(
                                projectName: sProjectName,
                                index: index,
                              )));
                },
              );
            }));
  }
}
