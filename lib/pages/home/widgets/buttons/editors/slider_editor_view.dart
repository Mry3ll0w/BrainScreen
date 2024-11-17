import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/pages/home/widgets/buttons/button_payload_editor.dart';
import 'package:brainscreen/pages/home/widgets/buttons/buttons_settings.dart';
import 'package:brainscreen/pages/models/slider_model.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

// EDITOR DE ELEVATED BUTTONS

class SliderSettingsEdit extends StatefulWidget {
  String _projectName = "";
  CustomSliderModel? selectedButton;
  final user = FirebaseAuth.instance.currentUser;

  SliderSettingsEdit(
      {required super.key,
      required String sProjectName,
      required CustomSliderModel btn}) {
    _projectName = sProjectName;
    selectedButton = btn; //! FIX UPDATE CRUZADO DE SLIDER Y SWITCH
  }

  @override
  State<SliderSettingsEdit> createState() => _SliderSettingsEditState();
}

class _SliderSettingsEditState extends State<SliderSettingsEdit> {
  final Future<List<CustomSliderModel>> _lElevatedButtons = Future.value([]);

  static final _auth = FirebaseAuth.instance;
  String? sBaseURLError;
  String? sLabelErrorText;
  String? sAPIErrorText;
  String? sPayloadErrorText;
  String? sPositionErrorText;
  int iPos = 0;

  final List<String> _lsPetitionType = ['POST', 'PUT'];

  CustomSliderModel newButton = CustomSliderModel(
      label: '',
      labelText: '',
      type: '',
      position: '',
      baseurlPost: 'baseURL',
      apiurlPost: 'apiURL',
      payload: 'payload',
      dValue: 20);
  @override
  void initState() {
    super.initState();

    newButton = widget.selectedButton!;
    // Parse elementos API Switch/Slider a APIURL
    WidgetController.fetchSliderIndexByLabel(
            widget._projectName, widget.selectedButton!.label)
        .then((v) {
      iPos = v;
    });
    //Comprobamos si se trata de un Switch, para en caso de serlo desplegar un dialog.
    // Retrasar la verificación del tipo de botón para asegurar que el widget esté completamente inicializado
    // Future.delayed(Duration.zero, () {
    //   _showSwitchRequirements(widget.key); //Mostramos el pop up
    // });
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
              body: SingleChildScrollView(
                child: Padding(
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
                                'Texto que quieres que tenga el slider.',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.save),
                              onPressed: () async {
                                if (sLabelErrorText == null) {
                                  bool bRes = await _buttonFieldUpdate(
                                      widget._projectName,
                                      'labelText',
                                      newButton.labelText,
                                      widget.key,
                                      widget.selectedButton!.type);
                                  if (bRes) {
                                    setState(() {
                                      widget.selectedButton!.labelText =
                                          newButton.labelText;
                                    });
                                  }
                                }
                              },
                            ),
                            label: Text(widget.selectedButton!.labelText)),
                        onChanged: (value) {
                          setState(() {
                            newButton.labelText = value;
                          });
                          if (value.isEmpty) {
                            sLabelErrorText = 'No puedes dejar vacio ese campo';
                          } else {
                            sLabelErrorText = null;
                          }
                        },
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: BrainColors.backgroundColor,
                        title: const Text(
                          'Como consumimos los datos al slider',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: indicacionesUso_(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            //ELIMINAR WIDGET
                            bool bErased =
                                await WidgetController.eraseWidgetFromLienzo(
                                    widget._projectName,
                                    widget.selectedButton!.label,
                                    true);
                            if (bErased) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home.named(
                                            title: widget._projectName,
                                            projectToLoad: widget._projectName,
                                          )));
                            } else {
                              //Se ha generado algun tipo de error, mostramos dialog
                              WidgetController.genericErrorDialog(
                                  widget._projectName,
                                  widget.key,
                                  context,
                                  'Se ha producido un error al borrar el widget, intentelo mas tarde.');
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 30,
                          ),
                          label: const Text(
                            'Borrar slider',
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home.named(
                                          title: widget._projectName,
                                          projectToLoad: widget._projectName)));
                            },
                            icon: const Icon(
                              Icons.beenhere_sharp,
                              size: 30,
                            ),
                            label: const Text(
                              'Volver al lienzo',
                              style: TextStyle(fontSize: 20),
                            ),
                          ))
                    ],
                  ),
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
  /// - `type`: Determina el tipo del boton {ElevatedButton(0), Switch(1), Slider(0) }
  Future<bool> _buttonFieldUpdate(String sProjectName, String field,
      dynamic newfieldValue, var key, String type) async {
    //Si esta vacio pasamos de hacer nada
    if (newfieldValue.isNotEmpty) {
      // Primero buscamos en el lienzo que toque

      //Debemos controlar si se trata de un switch/slider u boton;
      List lElevatedButtons;

      //Slider
      lElevatedButtons =
          await WidgetController.fetchAllButtonsFromProject(sProjectName);
      int iPosBtn = 0;
      for (var rawButton in lElevatedButtons) {
        if (newButton.label == rawButton['label']) {
          break;
        }
        iPosBtn++;
      }
      debugPrint('Ruta obtenida "lienzo/$sProjectName/buttons/$iPosBtn');
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

  Widget indicacionesUso_() {
    return Column(children: [
      Text(
          'Para leer datos debes realizar una peticion GET siguiendo el siguiente esquema:\n',
          style: TextStyle(
            fontSize: 15 *
                MediaQuery.of(context).size.width /
                360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
          )),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Petition',
                style: TextStyle(
                  fontSize: 20 *
                      MediaQuery.of(context).size.width /
                      360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
                )),
            JsonView.string(
              '{"URL":"http://3.210.108.248:3000/sliders/${widget._projectName}/$iPos"}',
              theme: const JsonViewTheme(viewType: JsonViewType.base),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Params',
                style: TextStyle(
                  fontSize: 20 *
                      MediaQuery.of(context).size.width /
                      360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
                )),
            JsonView.string(
              '{"firebaseuid":"${_auth.currentUser!.uid}", "amazonuid":""}',
              theme: const JsonViewTheme(viewType: JsonViewType.base),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 5),
        child: Text(
            'Para agregar usa una peticion PUT siguiendo el siguiente esquema:\n',
            style: TextStyle(
              fontSize: 20 *
                  MediaQuery.of(context).size.width /
                  360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Petition',
                style: TextStyle(
                  fontSize: 20 *
                      MediaQuery.of(context).size.width /
                      360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
                )),
            JsonView.string(
              '{"URL":"http://3.210.108.248:3000/charts/${widget._projectName}/$iPos"}',
              theme: const JsonViewTheme(viewType: JsonViewType.base),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Params',
                style: TextStyle(
                  fontSize: 20 *
                      MediaQuery.of(context).size.width /
                      360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
                )),
            JsonView.string(
              '{"firebaseuid":"${_auth.currentUser!.uid}", "amazonuid":""}',
              theme: const JsonViewTheme(viewType: JsonViewType.base),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Body',
                style: TextStyle(
                  fontSize: 20 *
                      MediaQuery.of(context).size.width /
                      360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
                )),
            JsonView.string(
              '{"value":"10"}',
              theme: const JsonViewTheme(viewType: JsonViewType.base),
            ),
          ],
        ),
      )
    ]);
  }
}
