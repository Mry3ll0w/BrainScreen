import 'dart:core';

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
  const ChartModelView({super.key});

  @override
  State<ChartModelView> createState() => _ChartModelViewState();
}

class _ChartModelViewState extends State<ChartModelView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
