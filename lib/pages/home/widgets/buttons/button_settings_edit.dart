import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/widgets/buttons/buttons_settings.dart';
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

  String? sBaseURLError;
  String? sLabelErrorText;
  String? sAPIErrorText;
  String? sPayloadErrorText;
  String? sPositionErrorText;

  ElevatedButtonModel newButton = ElevatedButtonModel(
      label: '',
      labelText: '',
      type: '',
      petition: '',
      baseURL: 'baseURL',
      apiURL: 'apiURL',
      payload: 'payload');

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
                          errorText: sLabelErrorText,
                          helperText:
                              'Texto que quieres que tenga el pulsador.',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: () async {
                              if (sLabelErrorText == null) {
                                bool bRes = await _buttonFieldUpdate(
                                    widget._projectName,
                                    'labelText',
                                    newButton.labelText_,
                                    widget.key);
                                if (bRes) {
                                  setState(() {
                                    widget.selectedButton!.labelText_ =
                                        newButton.labelText_;
                                  });
                                }
                              }
                            },
                          ),
                          label: Text(widget.selectedButton!.labelText_)),
                      onChanged: (value) {
                        setState(() {
                          newButton.labelText_ = value;
                        });
                        if (value.isEmpty) {
                          sLabelErrorText = 'No puedes dejar vacio ese campo';
                        } else {
                          sLabelErrorText = null;
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, top: 15),
                      child: TextField(
                        decoration: InputDecoration(
                            filled: true,
                            errorText: sBaseURLError,
                            helperText:
                                'Ruta base del servidor al que realizar la peticion',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.save),
                              onPressed: () async {
                                if (sBaseURLError != null) {
                                  _buttonFieldUpdate(
                                      widget._projectName,
                                      'labelText',
                                      widget.selectedButton?.labelText_,
                                      widget.key);
                                }
                              },
                            ),
                            label: Text(widget.selectedButton!.baseURL_)),
                        onChanged: (value) {
                          setState(() {
                            widget.selectedButton?.baseURL_ = value;
                          });
                          if (!value.contains('http://')) {
                            sBaseURLError =
                                'Tiene que agregar http:// a la URL del servidor.';
                          } else {
                            sBaseURLError = null;
                          }
                        },
                      ),
                    )
                  ],
                ),
              ));
        }
      },
    );
  }

  /// Muestra un mensaje de error usando dialog si se produce alguno
  void _updateErrorDialog(String sProjectName, var key) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                            Text('Error de actualizacion intentelo de nuevo.'),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ButtonSettingsList(
                                    key: key,
                                    sProjectName:
                                        sProjectName)), // Replace NewView with the class of your new view
                          );
                        },
                        child: const Text('Cerrar'),
                      )
                    ]))));
  }

  // Función genérica para actualizar los campos requeridos de un ElevatedButton dentro de un proyecto específico.
  ///
  /// Esta función busca un ElevatedButton por su nombre en un conjunto de botones asociados con un proyecto especificado,
  /// y luego actualiza uno o más de sus campos basándose en los valores proporcionados. La actualización se realiza
  /// mediante una operación asíncrona que interactúa con Firebase Reaktime Database.
  ///
  /// Los parámetros son:
  /// - `sProjectName`: El nombre del proyecto al cual pertenece el botón a ser actualizado.
  /// - `field`: El campo específico del botón que se desea actualizar.
  /// - `newfieldValue`: El nuevo valor que se asignará al campo especificado.
  /// - `key`: Una clave opcional que puede ser utilizada para identificar el contexto de la actualización.
  Future<bool> _buttonFieldUpdate(
      String sProjectName, String field, dynamic newfieldValue, var key) async {
    //Si esta vacio pasamos de hacer nada
    if (newfieldValue.isNotEmpty) {
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
        await ref.update({field: newfieldValue});
        return true;
      } catch (e) {
        // Print Dialog Error
        _updateErrorDialog(sProjectName, key);
        return false;
      }
    } else {
      return false;
    }
  }
}
