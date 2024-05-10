import 'package:flutter/material.dart';

class ButtonSettings extends StatefulWidget {
  const ButtonSettings({super.key});

  @override
  State<ButtonSettings> createState() => _ButtonSettingsState();
}

class _ButtonSettingsState extends State<ButtonSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings'),
      ),
    );
  }
}
