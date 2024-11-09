import 'dart:math';

import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/models/chart_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

class ChartSettingsView extends StatefulWidget {
  const ChartSettingsView(
      {super.key, required String sProjectName, required this.index})
      : projectName = sProjectName;
  final int index;
  final String? projectName;

  @override
  State<ChartSettingsView> createState() => _ChartSetupState();
}

class _ChartSetupState extends State<ChartSettingsView> {
  //Variables de customizacion
  String sXAxisText = 'Texto Eje X', sYAxisText = 'Texto Eje Y';
  String sLabelText = 'Grafismo';

  ChartModel chart = ChartModel(
      '', 'labelText', 'sXAxisText', 'sYAxisText_', <double, double>{});

  @override
  void initState() {
    //Inicializamos el fw
    initializeChartModelValues(widget.projectName ?? "", widget.index, chart);
    super.initState();
    //Listener de cambios
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edita tu Grafismo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    Text(
                      sLabelText,
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 200,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: LineChart(LineChartData(
                      backgroundColor: const Color.fromARGB(255, 132, 131, 123)
                          .withOpacity(0.7),
                      titlesData: FlTitlesData(
                          show: true,
                          bottomTitles:
                              AxisTitles(axisNameWidget: Text(sXAxisText)),
                          leftTitles:
                              AxisTitles(axisNameWidget: Text(sYAxisText))),
                      lineBarsData: [
                        LineChartBarData(
                            color: const Color.fromARGB(255, 7, 7, 7),
                            spots: initializeData(),
                            isCurved: true,
                            belowBarData: BarAreaData(
                                color: const Color.fromARGB(255, 25, 145, 244)
                                    .withOpacity(0.6),
                                show: true)),
                      ])),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    initialValue: chart.sXAxisText,
                    onChanged: (value) => {
                          setState(() {
                            chart.sXAxisText = value;
                          })
                        },
                    decoration: InputDecoration(
                      hintText: 'Etiqueta del eje X',
                      errorText: chart.sXAxisText.isEmpty
                          ? 'La etiqueta de coordenadas no puede estar vacia'
                          : null,
                      helperText: 'Eje de Coordenadas (X)',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    initialValue: chart.sXAxisText,
                    onChanged: (value) => {
                          setState(() {
                            chart.sYAxisText = value;
                          })
                        },
                    decoration: InputDecoration(
                      hintText: 'Etiqueta del eje Y',
                      errorText: chart.sYAxisText.isEmpty
                          ? 'La etiqueta de ordenadas no puede estar vacia'
                          : null,
                      helperText: 'Eje de Coordenadas (Y)',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    initialValue: chart.labelText,
                    onChanged: (value) => {
                          setState(() {
                            chart.labelText = value;
                          })
                        },
                    decoration: InputDecoration(
                      hintText: 'Titulo del Grafismo',
                      errorText: chart.labelText.isEmpty
                          ? 'El titulo del grafismo no puede estar vacio'
                          : null,
                      helperText: 'Titulo del grafismo, ej: Grafo',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 50, left: 30, right: 30),
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      if (chart.labelText.isEmpty ||
                          chart.sXAxisText.isEmpty ||
                          chart.sYAxisText.isEmpty) {
                        WidgetController.genericErrorDialog(
                            widget.projectName ?? "",
                            widget.key,
                            context,
                            "Corrige los errores antes de subir el elemento");
                      } else {
                        //TODO IMPLEMENT Metodo de widgetController
                        WidgetController.updateChartByModelAndProjectName(
                            chart, widget.index, widget.projectName ?? "");
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Home.named(
                        //               title: widget.projectName,
                        //               projectToLoad: widget.projectName,
                        //             )));
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Guardar Grafismo',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.save,
                        size: 40,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  // Load Chart Tiles Example
  List<FlSpot> initializeData() {
    List<FlSpot> lPoints = [];
    List<double> dlYpoints = [];
    Random random = Random();

    double xPoint = 0.0;
    for (int i = 0; i < 12; i++) {
      double dGeneratedY = random.nextDouble();
      dlYpoints.add(dGeneratedY);
      lPoints.add(FlSpot(xPoint, dGeneratedY));
      xPoint += 0.5;
    }
    // de menor a mayor
    dlYpoints.sort();

    return lPoints;
  }

  // Funcion para cargar el Json View
  Widget indicacionesUso_() {
    return Column(children: [
      Text(
          'Lo que estas viendo a continuacion se trata de una muestra.\nInicialmente se deberan subir datos a la BBDD siguiendo la siguiente estructura:\n',
          style: TextStyle(
            fontSize: 15 *
                MediaQuery.of(context).size.width /
                360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
          )),
      Padding(
        padding: const EdgeInsets.all(8),
        child: JsonView.string(
          '{"x":"[1,2,3,4,5,...]", "y":"[0.56, 0.46,54.2,...]"}',
          theme: const JsonViewTheme(viewType: JsonViewType.base),
        ),
      ),
    ]);
  }

  Future<void> initializeChartModelValues(
      String projectName, int index, ChartModel c) async {
    final databaseReference = FirebaseDatabase.instance
        .ref('/lienzo/$projectName/fieldWidgets/$index');
    final snapshot = await databaseReference.get();

    try {
      dynamic data = snapshot.value;
      setState(() {
        // Actualizar los campos
        c.data = data['apiurl'];
        c.label = data['label'];
        c.labelText_ = data['labelText'];
        c.sXAxisText = data['xAxisTitle'];
        c.sYAxisText_ = data['yAxisTitle'];
      });
      // ...
    } catch (e) {
      debugPrint('Error con data \n $e');
    }
  }
}
