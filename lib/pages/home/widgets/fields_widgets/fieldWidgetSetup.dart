import 'package:brainscreen/styles/brain_colors.dart';
import 'package:flutter/material.dart';

class Fieldwidgetsetup extends StatefulWidget {
  final String sProjectName;
  const Fieldwidgetsetup(
      {super.key, required projectName, required isNumberField})
      : sProjectName = projectName;

  @override
  State<Fieldwidgetsetup> createState() => _FieldwidgetsetupState();
}

class _FieldwidgetsetupState extends State<Fieldwidgetsetup> {
  String h1 = 'Vista previa del Widget';

  //Variables de inicializacion del Widget a crear.
  String sTextDefaultValue = '',
      sErrorText = 'Soy un mensaje de error',
      sPlaceHolder = 'Soy un placeHolder',
      sLabelText = 'Soy un labelText',
      sHelperText = 'Mensaje de ayuda';
  String? prevErrorText = null;

  bool bTestError = false;
  bool showErrorText = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              h1,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Container(
              child: Center(
                child: Column(
                  children: [
                    TextField(
                        onChanged: (value) => {
                              setState(() {
                                sTextDefaultValue = value;
                              })
                            },
                        style: const TextStyle(fontStyle: FontStyle.italic),
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.send),
                          errorText: prevErrorText,
                          fillColor: BrainColors.backgroundColor,
                          filled: true,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width:
                                    2.0), // Color del borde cuando está habilitado
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: BrainColors.mainBannerColor,
                                width:
                                    2.0), // Color del borde cuando está enfocado
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          labelText: sLabelText,
                          helperText: sHelperText,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          const Text('Mostrar mensaje de error'),
                          Switch(
                              value: showErrorText,
                              onChanged: (value) => {
                                    setState(() {
                                      showErrorText = value;
                                      prevErrorText = value ? sErrorText : null;
                                    })
                                  })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
