import 'dart:math';

import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/pages/models/chart_model.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

class ChartSetup extends StatefulWidget {
  const ChartSetup({super.key, required String? sProjectName})
      : projectName = sProjectName;

  final String? projectName;

  @override
  State<ChartSetup> createState() => _ChartSetupState();
}

class _ChartSetupState extends State<ChartSetup> {
  //Variables de customizacion
  String sXAxisText = 'Texto Eje X', sYAxisText = 'Texto Eje Y';
  String sLabelText = 'Diagrama';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configura tu Diagrama'),
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
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: BrainColors.backgroundColor,
                title: const Text(
                  'Aclaraciones de los grafismos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: indicacionesUso_(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    initialValue: sXAxisText,
                    onChanged: (value) => {
                          setState(() {
                            sXAxisText = value;
                          })
                        },
                    decoration: InputDecoration(
                      hintText: 'Etiqueta del eje X',
                      errorText: sXAxisText.isEmpty
                          ? 'La etiqueta de coordenadas no puede estar vacia'
                          : null,
                      helperText: 'Eje de Coordenadas (X)',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    initialValue: sXAxisText,
                    onChanged: (value) => {
                          setState(() {
                            sYAxisText = value;
                          })
                        },
                    decoration: InputDecoration(
                      hintText: 'Etiqueta del eje Y',
                      errorText: sYAxisText.isEmpty
                          ? 'La etiqueta de ordenadas no puede estar vacia'
                          : null,
                      helperText: 'Eje de Coordenadas (Y)',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    initialValue: sLabelText,
                    onChanged: (value) => {
                          setState(() {
                            sLabelText = value;
                          })
                        },
                    decoration: InputDecoration(
                      hintText: 'Titulo del Diagrama',
                      errorText: sLabelText.isEmpty
                          ? 'El titulo del diagrama no puede estar vacio'
                          : null,
                      helperText: 'Titulo del diagrama, ej: Grafo',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 50, left: 30, right: 30),
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      if (sLabelText.isEmpty ||
                          sXAxisText.isEmpty ||
                          sYAxisText.isEmpty) {
                        WidgetController.genericErrorDialog(
                            widget.projectName ?? "",
                            widget.key,
                            context,
                            "Corrige los errores antes de subir el elemento");
                      } else {
                        //Agregamos a la lista de charts del lienzo.
                        WidgetController.addChartToLienzo(
                            widget.projectName ?? "",
                            ChartModel(
                                '', sLabelText, sXAxisText, sYAxisText, {}));
                        // Despues de agregar nos volvemos al home
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home.named(
                                      title: widget.projectName,
                                      projectToLoad: widget.projectName,
                                    )));
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Guardar y enviar',
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
}
