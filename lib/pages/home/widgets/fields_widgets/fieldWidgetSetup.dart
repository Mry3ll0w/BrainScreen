import 'package:flutter/material.dart';

class Fieldwidgetsetup extends StatefulWidget {
  final String sProjectName;
  final bool bIsNumberField;
  const Fieldwidgetsetup(
      {super.key, required projectName, required isNumberField})
      : sProjectName = projectName,
        bIsNumberField = isNumberField;

  @override
  State<Fieldwidgetsetup> createState() => _FieldwidgetsetupState();
}

class _FieldwidgetsetupState extends State<Fieldwidgetsetup> {
  String H1 = 'Vista previa del ';

  @override
  void initState() {
    super.initState();

    // Para placeholders
    if (widget.bIsNumberField) {
      H1 += 'NumberField';
    } else {
      H1 += 'TextField';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              H1,
              style: const TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
