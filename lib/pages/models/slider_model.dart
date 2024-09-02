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
