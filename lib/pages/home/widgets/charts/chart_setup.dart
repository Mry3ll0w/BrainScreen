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
                width: 200,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: LineChart(LineChartData(
                      backgroundColor: const Color.fromARGB(255, 132, 131, 123)
                          .withOpacity(0.7),
                      titlesData: const FlTitlesData(
                          show: true,
                          bottomTitles:
                              AxisTitles(axisNameWidget: Text('Titulo eje x')),
                          leftTitles:
                              AxisTitles(axisNameWidget: Text('Titulo eje y'))),
                      lineBarsData: [
                        LineChartBarData(
                            color: Color.fromARGB(255, 7, 7, 7),
                            spots: initializeData(),
                            isCurved: true,
                            belowBarData: BarAreaData(
                                color: const Color.fromARGB(255, 25, 145, 244)
                                    .withOpacity(0.6),
                                show: true)),
                      ])),
                ),
              )
            ],
          ),
        ));
  }

  // Load Chart Tiles Example
  List<FlSpot> initializeData() {
    List<FlSpot> lPoints = [];
    Random random = Random();

    double xPoint = 0.0;
    for (int i = 0; i < 50; i++) {
      lPoints.add(FlSpot(xPoint, random.nextDouble()));
      xPoint += 0.5;
    }

    return lPoints;
  }
}
