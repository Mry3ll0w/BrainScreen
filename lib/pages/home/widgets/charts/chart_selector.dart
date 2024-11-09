import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:flutter/material.dart';

class ChartSelector extends StatelessWidget {
  const ChartSelector({super.key, required String sprojectName})
      : projectName = sprojectName;
  final String projectName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadAllchTiles(projectName),
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
  Future<Widget> _loadAllchTiles(String projectName) async {
    List<dynamic> lCharts =
        await WidgetController.fetchAllChartsRAW(projectName);

    return Scaffold(
        appBar: AppBar(title: const Text('Lista de Grafismos')),
        body: _buildListTiles(lCharts, projectName));
  }

  Widget _buildListTiles(List<dynamic> lCharts, String sProjectName) {
    List<Widget> lTiles = [];

    for (var ch in lCharts) {
      // Preparamos La lista de Filas
      lTiles.add(ListTile(
        leading: const Icon(Icons.auto_graph),
        title: Text(ch['labelText']),
        subtitle: const Text('Grafica Linear'),
      ));
      // Parseamos de Switch a button
    }

    return Container(
        margin: const EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: lTiles.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.auto_graph),
                title: Text(lCharts[index]['labelText']),
                onTap: () async {
                  int iGlobalIndex =
                      await WidgetController.getFieldWidgetPositionByLabel(
                          sProjectName, lCharts[index]['label']);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => FieldWidgetEditorView(
                  //               projectName: sProjectName,
                  //               index: iGlobalIndex,
                  //             )));
                },
              );
            }));
  }
}
