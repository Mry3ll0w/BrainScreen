import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/models/button_model.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ButtonSettingsEdit extends StatefulWidget {
  String _projectName = "";
  ElevatedButtonModel? selectedButton;
  final user = FirebaseAuth.instance.currentUser;

  ButtonSettingsEdit(
      {required super.key,
      required String sProjectName,
      required ElevatedButtonModel btn}) {
    _projectName = sProjectName;
    selectedButton = btn;
  }

  @override
  State<ButtonSettingsEdit> createState() => _ButtonSettingsEditState();
}

class _ButtonSettingsEditState extends State<ButtonSettingsEdit> {
  Future<List<ElevatedButtonModel>> _lElevatedButtons = Future.value([]);

  @override
  void initState() {
    super.initState();
    _lElevatedButtons =
        WidgetController.fetchElevatedButtonsModels(widget._projectName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _lElevatedButtons,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Mostrar un indicador de carga mientras se espera
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Text(
              'Error al cargar los datos'); // Manejar el caso de error o datos nulos
        } else {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Parámetros del botón'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 12, left: 8, right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: BrainColors.backgroundColor,
                          border: Border.all(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'En esta seccion podras ajustar las variables del elemento seleccionado, pulsa el icono de guardar para que se guarden los cambios. ',
                            style: TextStyle(
                              fontSize: 20 *
                                  MediaQuery.of(context).size.width /
                                  360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          filled: true,
                          helperText:
                              'Nombre que quieres que tenga el pulsador.',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: () async {
                              changeLabelText(widget._projectName,
                                  widget.selectedButton!.labelText_);
                            },
                          ),
                          label: Text(widget.selectedButton!.labelText_)),
                      onChanged: (value) {
                        setState(() {
                          widget.selectedButton?.labelText_ = value;
                        });
                      },
                    ),
                  ],
                ),
              )); // Asignar directamente snapshot.data ya que hemos verificado que no es null
        }
      },
    );
  }

  Future<void> changeLabelText(String sProjectName, String newLabelText) async {
    //Si esta vacio pasamos de hacer nada
    if (newLabelText.isNotEmpty) {
      // Primero buscamos en el lienzo que toque
      var lElevatedButtons =
          await WidgetController.fetchAllElevatedButtons(sProjectName);

      int iPosBtn = 0;
      for (var rawButton in lElevatedButtons) {
        if (widget.selectedButton?.label_ == rawButton['label']) {
          break;
        }
        iPosBtn++;
      }

      //Una vez obtenida la posicion del boton lo actualizamos.

      try {
        DatabaseReference ref = FirebaseDatabase.instance
            .ref("lienzo/$sProjectName/buttons/$iPosBtn");
        await ref.update({"labelText": newLabelText});
      } catch (e) {
        // Print Dialog Error
      }
    }
  }
}
