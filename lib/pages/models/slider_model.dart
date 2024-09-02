import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final Function()? onLongPressed;

  const CustomSlider({
    this.onLongPressed,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _currentSliderValue = 20;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen_size = MediaQuery.of(context).size;
    return GestureDetector(
      onLongPress: () {
        if (widget.onLongPressed != null) {
          widget.onLongPressed!();
        }
      },
      child: SliderTheme(
        data: SliderThemeData(
          thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: screen_size.width < 400 ? 8 : 12),
          trackHeight: screen_size.width < 400 ? 6 : 8,
        ),
        child: Slider(
          value: _currentSliderValue,
          max: 100,
          divisions: 10,
          label: _currentSliderValue.toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        ),
      ),
    );
  }
}

// Modelo de clase

class CustomSliderModel {
  // Declaramos los atributos

  String _type = '', _position = '';
  String _label = '', _labelText = '', _baseURL_POST = '', _apiURL_POST = '';
  dynamic _payload = {};

  double value = 0.00;

  // Constructor
  CustomSliderModel(
      {required String type,
      required String position,
      required String label,
      required String labelText,
      required String baseurlPost,
      required String apiurlPost,
      required dynamic payload,
      required double dValue})
      : _type = type,
        _position = position,
        _label = label,
        _labelText = labelText,
        _baseURL_POST = baseurlPost,
        _apiURL_POST = apiurlPost,
        _payload = payload,
        value = dValue;

  // Getters
  String get type => _type;
  set type(String value) => _type = value;

  String get position => _position;
  set position(String value) => _position = value;

  String get label => _label;
  set label(String value) => _label = value;

  String get labelText => _labelText;
  set labelText(String value) => _labelText = value;

  String get baseURLPOST => _baseURL_POST;
  set baseURLPOST(String value) => _baseURL_POST = value;

  String get apiURLPOST => _apiURL_POST;
  set apiURLPOST(String value) => _apiURL_POST = value;

  dynamic get payload => _payload;
  set payload(dynamic value) => _payload = value;

  // Método para manejar errores de petición
  void _petitionErrorNotification(
      int errorCode, String projectName, bool isTimeException) {
    // Implementación existente...
  }

  // Método para construir el widget
  Widget buildSwitchWidget(key, String projectName) {
    return const CustomSlider();
  }
}
