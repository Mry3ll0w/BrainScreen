import 'package:flutter/material.dart';

class FieldWidgetModel {
  String label_, labelText_, baseURL_, apiURL_, widgetValue_;
  bool bIsNumberField_;
  dynamic payload_;

  // Constructor predeterminado, inicializamos los elementos minimos de los widgets
  FieldWidgetModel(
      {required String label,
      required String labelText,
      required String baseURL,
      required String apiURL,
      required String widgetValue,
      required bool numberField,
      required dynamic payload})
      : label_ = label,
        labelText_ = labelText,
        baseURL_ = baseURL,
        apiURL_ = apiURL,
        widgetValue_ = widgetValue,
        bIsNumberField_ = numberField;

  // Now we generate all the getters and setters.

  // Getters
  String get label => label_;
  String get labelText => labelText_;
  String get baseURL => baseURL_;
  String get apiURL => apiURL_;
  String get widgetValue => widgetValue_;
  bool get isNumberField => bIsNumberField_;
  dynamic get payload => payload_;

  // Setters
  set label(String value) => label_ = value;
  set labelText(String value) => labelText_ = value;
  set baseURL(String value) => baseURL_ = value;
  set apiURL(String value) => apiURL_ = value;
  set widgetValue(String value) => widgetValue_ = value;
  set isNumberField(bool value) => bIsNumberField_ = value;
  set payload(dynamic value) => payload_ = value;
}

class FieldWidgetView extends StatefulWidget {
  const FieldWidgetView({super.key});

  @override
  State<FieldWidgetView> createState() => _FieldWidgetViewState();
}

class _FieldWidgetViewState extends State<FieldWidgetView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
