import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartModel {
  //Elementos que debe tener como minimo
  String label_, labelText_, sXAxisText_, sYAxisText_;

  Map<double, double> data_;

  ChartModel(String label, String labelText, String sXAxisText,
      String sYAxisText_, Map<double, double> data)
      : label_ = label,
        labelText_ = labelText,
        sXAxisText_ = sXAxisText,
        data_ = data,
        sYAxisText_ = sXAxisText;

  //Getters and Setter
  // Getters y setters

  String get label => label_;
  set label(String value) => label_ = value;

  String get labelText => labelText_;
  set labelText(String value) => labelText_ = value;

  String get sXAxisText => sXAxisText_;
  set sXAxisText(String value) => sXAxisText_ = value;

  String get sYAxisText => sYAxisText_;
  set sYAxisText(String value) => sYAxisText_ = value;

  Map<double, double> get data => data_;
  set data(Map<double, double> value) => data_ = value;

  void addDataToGraph(Map<double, double> dmpNewData) {
    if (dmpNewData.isNotEmpty) {
      data_.addAll(dmpNewData);
    }
  }

  void addStringDataToGraph(Map<String, String> smpNewData) {
    if (smpNewData.isNotEmpty) {
      //Parseamos los elementos
      smpNewData.forEach((xValue, yValue) {
        // Parseamos a cada elemento
        data_.addAll({double.parse(xValue): double.parse(yValue)});
      });
    }
  }
}

class ChartModelView extends StatefulWidget {
  ChartModelView(
      {super.key, required String projectName, required ChartModel c})
      : sProjectName = projectName,
        chart = c;

  final String sProjectName;
  ChartModel chart;

  @override
  State<ChartModelView> createState() => _ChartModelViewState();
}

class _ChartModelViewState extends State<ChartModelView> {
  // Listener de cambios
  late StreamSubscription _subscriptionFwDataChanges;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
            child: Column(
              children: [
                Text(
                  widget.chart.labelText,
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
                  backgroundColor:
                      const Color.fromARGB(255, 132, 131, 123).withOpacity(0.7),
                  titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                          axisNameWidget: Text(widget.chart.sXAxisText)),
                      leftTitles: AxisTitles(
                          axisNameWidget: Text(widget.chart.sYAxisText))),
                  lineBarsData: [
                    LineChartBarData(
                        color: const Color.fromARGB(255, 7, 7, 7),
                        spots: initializeData(widget.chart.data),
                        isCurved: true,
                        belowBarData: BarAreaData(
                            color: const Color.fromARGB(255, 25, 145, 244)
                                .withOpacity(0.6),
                            show: true)),
                  ])),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // Init del listener de cambios
    setupvalueChangerListener(widget.sProjectName, widget.chart, 0);

    super.initState();
  }

  List<FlSpot> initializeData(Map<double, double> mp) {
    List<FlSpot> lPoints = [];
    // Recorremos los datos para inicializarlos
    mp.forEach((x, y) {
      lPoints.add(FlSpot(x, y));
    });
    return lPoints;
  }

  //Data Update onChange
  void setupvalueChangerListener(
      String projectName, ChartModel chart, int iPos) {
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
          widget.chart.data = parseToMap(data['data']);
          widget.chart.label = data['label'];
          widget.chart.labelText = data['labelText'];
          widget.chart.sXAxisText = data['xAxisTitle'];
          widget.chart.sYAxisText = data['yAxisTitle'];
        });

        // ...
      } catch (e) {
        debugPrint('Error con data \n $e');
      }
    });
  }

  Map<double, double> parseToMap(dynamic data) {
    Map<double, double> mpValues = {1.0: 1, 2.0: 2, 3: 3.0};

    //Trata

    return mpValues;
  }
}
