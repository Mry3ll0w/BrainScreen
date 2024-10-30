import 'dart:math';

import 'package:brainscreen/pages/home/widgets/charts/chart_example.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartSetup extends StatefulWidget {
  const ChartSetup({super.key, required String? sProjectName})
      : projectName = sProjectName;

  final String? projectName;

  @override
  State<ChartSetup> createState() => _ChartSetupState();
}

class _ChartSetupState extends State<ChartSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configura tu Grafismo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              SizedBox(
                width: 400,
                height: 200,
                child: LineChart(LineChartData(lineBarsData: [
                  LineChartBarData(
                    color: Colors.red,
                    spots: initializeData(),
                  ),
                ])),
              )
            ],
          ),
        ));
  }

  // Load Chart Tiles Example
  List<FlSpot> initializeData() {
    List<FlSpot> lPoints = [];
    Random random = Random();

    // Generar dos números aleatorios dobles
    double num1 = random.nextDouble();
    double num2 = random.nextDouble();
    double xPoint = 0.0;
    for (int i = 0; i < 50; i++) {
      lPoints.add(FlSpot(xPoint, random.nextDouble()));
      xPoint += 0.5;
    }

    return lPoints;
  }
}
