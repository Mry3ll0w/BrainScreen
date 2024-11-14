import 'dart:async';
import 'package:brainscreen/pages/controllers/project_controller.dart';
import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/pages/models/chart_model.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  ChartModel chart = ChartModel(
      '', 'labelText', 'sXAxisText', 'sYAxisText_', <double, double>{});
  late StreamSubscription _subscriptionFwDataChanges;
  @override
  void initState() {
    super.initState();
    initializeChartModelValues(widget.projectName ?? "", widget.index, chart);
    setupvalueChangerListener(widget.projectName ?? "", chart, widget.index);
  }

  static final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edita tu Diagrama'),
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
                      chart.labelText,
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
                          bottomTitles: AxisTitles(
                              axisNameWidget: Text(chart.sXAxisText)),
                          leftTitles: AxisTitles(
                              axisNameWidget: Text(chart.sYAxisText))),
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
                      hintText: 'Titulo del Diagrama',
                      errorText: chart.labelText.isEmpty
                          ? 'El titulo del diagrama no puede estar vacio'
                          : null,
                      helperText: 'Titulo del diagrama, ej: Grafo',
                    )),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: BrainColors.backgroundColor,
                title: const Text(
                  'Como agregar datos al diagrama',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: indicacionesUso_(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10, left: 30, right: 30),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    //ELIMINAR WIDGET
                    bool bErased = await WidgetController.eraseChartFromLienzo(
                        widget.projectName ?? "", widget.index);
                    if (bErased) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home.named(
                                    title: widget.projectName,
                                    projectToLoad: widget.projectName,
                                  )));
                    } else {
                      //Se ha generado algun tipo de error, mostramos dialog
                      WidgetController.genericErrorDialog(
                          widget.projectName ?? "",
                          widget.key,
                          context,
                          'Se ha producido un error al borrar el widget, intentelo mas tarde.');
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 30,
                  ),
                  label: const Text(
                    'Borrar Diagrama',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
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
                        WidgetController.updateChartByModelAndProjectName(
                            chart, widget.index, widget.projectName ?? "");
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
                        'Guardar Diagrama',
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
    chart.data.forEach((x, y) {
      lPoints.add(FlSpot(x, y));
    });

    return lPoints;
  }

  // Funcion para cargar el Json View
  Widget indicacionesUso_() {
    return Column(children: [
      Text(
          'Para agregar datos debes realizar una peticion PUT siguiendo el siguiente esquema:\n',
          style: TextStyle(
            fontSize: 15 *
                MediaQuery.of(context).size.width /
                360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
          )),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Petition',
                style: TextStyle(
                  fontSize: 20 *
                      MediaQuery.of(context).size.width /
                      360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
                )),
            JsonView.string(
              '{"URL":"http://3.210.108.248:3000/charts/${widget.projectName}/${widget.index}"}',
              theme: const JsonViewTheme(viewType: JsonViewType.base),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Params',
                style: TextStyle(
                  fontSize: 20 *
                      MediaQuery.of(context).size.width /
                      360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
                )),
            JsonView.string(
              '{"firebaseuid":"${_auth.currentUser!.uid}", "amazonuid":""}',
              theme: const JsonViewTheme(viewType: JsonViewType.base),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Body',
                style: TextStyle(
                  fontSize: 20 *
                      MediaQuery.of(context).size.width /
                      360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
                )),
            JsonView.string(
              '{"x":"[1,2,3,4,5,...]", "y":"[0.56, 0.46,54.2,...]"}',
              theme: const JsonViewTheme(viewType: JsonViewType.base),
            ),
          ],
        ),
      )
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
        c.sYAxisText_ = data['data'];
      });
      // ...
    } catch (e) {
      debugPrint('Error con data chart sett \n $e');
    }
  }

  //Data Update onChange
  void setupvalueChangerListener(String projectName, ChartModel ch, int iPos) {
    // Pillamos El fieldWidget a controlar
    final databaseReference =
        FirebaseDatabase.instance.ref('/lienzo/$projectName/charts/$iPos');

    _subscriptionFwDataChanges =
        databaseReference.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      debugPrint(snapshot.value.toString());
      try {
        dynamic data = snapshot.value;
        setState(() {
          chart.data = data['data'] ?? <double, double>{};
          chart.labelText = data['labelText'].toString();
          chart.label = data['label'];
          chart.sXAxisText = data['xAxisTitle'];
          chart.sYAxisText = data['yAxisTitle'];
        });
        // ...
      } catch (e) {
        debugPrint('Error con data \n $e');
      }
    });
  }
}
