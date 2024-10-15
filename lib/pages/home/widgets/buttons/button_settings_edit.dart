import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/pages/home/widgets/buttons/button_payload_editor.dart';
import 'package:brainscreen/pages/home/widgets/buttons/buttons_settings.dart';
import 'package:brainscreen/pages/models/button_model.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

// EDITOR DE ELEVATED BUTTONS

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

  final List<String> _lsPetitionType = ['POST', 'PUT'];

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
    // Parse elementos API Switch/Slider a APIURL

    //Comprobamos los campos a cambiar si es un switch u slider:
    if (widget.selectedButton != null && widget.selectedButton!.type_ == '1' ||
        widget.selectedButton!.type_ == '2') {
      newButton = widget.selectedButton!;

      //Ajustamos el campo fieldurl
    }

    //Comprobamos si se trata de un Switch, para en caso de serlo desplegar un dialog.
    // Retrasar la verificación del tipo de botón para asegurar que el widget esté completamente inicializado
    Future.delayed(Duration.zero, () {
      if (widget.selectedButton != null &&
              widget.selectedButton!.type_ == '1' ||
          widget.selectedButton!.type_ == '2') {
        // Tambien aplicable para sliders
        _showSwitchRequirements(widget.key);

        // Parseamos los elementos del switch/slider a button
      }
    });
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
                                'Texto que quieres que tenga el pulsador.',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.save),
                              onPressed: () async {
                                if (sLabelErrorText == null) {
                                  bool bRes = await _buttonFieldUpdate(
                                      widget._projectName,
                                      'labelText',
                                      newButton.labelText_,
                                      widget.key,
                                      widget.selectedButton!.type_);
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
                                  if (sBaseURLError == null) {
                                    bool bRes = true;
                                    if (widget.selectedButton!.type_ == '0') {
                                      bRes = await _buttonFieldUpdate(
                                          widget._projectName,
                                          'baseurl',
                                          newButton.baseURL_,
                                          widget.key,
                                          widget.selectedButton!.type_);
                                    } else if (widget.selectedButton!.type_ ==
                                        '1') {
                                      //Switch
                                      bRes = await _buttonFieldUpdate(
                                          widget._projectName,
                                          'baseurl_post',
                                          newButton.baseURL_,
                                          widget.key,
                                          widget.selectedButton!.type_);
                                    } else {
                                      //TODO AGREGAR SLIDER CUANDO ESTE LISTO
                                    }
                                    if (bRes) {
                                      setState(() {
                                        widget.selectedButton!.baseURL_ =
                                            newButton.baseURL_;
                                      });
                                    }
                                  }
                                },
                              ),
                              label: Text(widget.selectedButton!.baseURL_)),
                          onChanged: (value) {
                            setState(() {
                              newButton.baseURL_ = value;
                            });
                            if (!value.contains('http://')) {
                              sBaseURLError =
                                  'Tiene que agregar http:// a la URL del servidor.';
                            } else {
                              sBaseURLError = null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: TextField(
                          decoration: InputDecoration(
                              filled: true,
                              errorText: sAPIErrorText,
                              helperText:
                                  'API del servidor que quieras consumir',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.save),
                                onPressed: () async {
                                  if (sAPIErrorText == null) {
                                    bool bRes = true;
                                    if (widget.selectedButton!.type_ == '0') {
                                      bRes = await _buttonFieldUpdate(
                                          widget._projectName,
                                          'apiurl',
                                          newButton.baseURL_,
                                          widget.key,
                                          widget.selectedButton!.type_);
                                    } else if (widget.selectedButton!.type_ ==
                                        '1') {
                                      // TODO FIX UPDATE SWITCH API VALUE
                                      debugPrint(
                                          'Estoy en el switch FIELD UPDATE');
                                      bRes = await _buttonFieldUpdate(
                                          widget._projectName,
                                          'apiurl_post',
                                          widget.selectedButton!.apiURL_,
                                          widget.key,
                                          widget.selectedButton!.type_);
                                    } else {
                                      //TODO AGREGAR SLIDER CUANDO ESTE LISTO
                                    }
                                    if (bRes) {
                                      setState(() {
                                        widget.selectedButton!.apiURL_ =
                                            newButton.apiURL_;
                                      });
                                    }
                                  }
                                },
                              ),
                              label: Text(widget.selectedButton!.apiURL_)),
                          onChanged: (value) {
                            setState(() {
                              newButton.apiURL_ = value;
                            });
                            if (!value.contains('/') && value.isEmpty) {
                              sAPIErrorText =
                                  'No puede estar vacia y ademas tiene que contener /';
                            } else {
                              sAPIErrorText = null;
                            }
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 15, top: 15),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Text(
                                    'HTTP Method',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                DropdownMenu<String>(
                                  enabled: widget.selectedButton!.type_ == '0'
                                      ? true
                                      : false,
                                  initialSelection:
                                      widget.selectedButton?.petition_,
                                  onSelected: (String? value) async {
                                    // Seleccion de item
                                    setState(() {
                                      newButton.petition_ = value!;
                                      widget.selectedButton?.petition_ = value;
                                    });
                                    await _buttonFieldUpdate(
                                        widget._projectName,
                                        'petition',
                                        newButton.petition_,
                                        widget.key,
                                        widget.selectedButton!.type_);
                                  },
                                  dropdownMenuEntries: _lsPetitionType
                                      .map<DropdownMenuEntry<String>>(
                                          (String value) {
                                    return DropdownMenuEntry<String>(
                                        value: value, label: value);
                                  }).toList(),
                                ),
                              ],
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JsonEditorView(
                                        sProjectName: widget._projectName,
                                        payload:
                                            widget.selectedButton?.payload_,
                                        label: widget.selectedButton!.label_)));
                          },
                          icon: const Icon(
                            Icons.javascript,
                            size: 40,
                          ),
                          label: const Text(
                            'Editar Payload',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            //ELIMINAR WIDGET
                            bool bErased =
                                await WidgetController.eraseWidgetFromLienzo(
                                    widget._projectName,
                                    widget.selectedButton!.label_,
                                    true); // TODO TEST que funcione
                            if (bErased) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home.named(
                                            title: widget._projectName,
                                            projectToLoad: widget._projectName,
                                          )));
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 30,
                          ),
                          label: const Text(
                            'Borrar pulsador',
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
      var lElevatedButtons =
          await WidgetController.fetchAllButtonsFromProject(sProjectName);

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

  //LO MISMO PERO PARA SWITCHES
  Future<bool> _switchFieldUpdate(
      String sProjectName, String field, dynamic newfieldValue, var key) async {
    //Si esta vacio pasamos de hacer nada
    debugPrint(
        'sProjectName: ${sProjectName} Field: ${field}, newFieldValue: ${newfieldValue}');
    if (newfieldValue.isNotEmpty) {
      // Primero buscamos en el lienzo que toque
      var lSwitches =
          await WidgetController.fetchAllSwitchesFromProject(sProjectName);

      int iPosBtn = 0;
      for (var sw in lSwitches) {
        if (widget.selectedButton?.label_ == sw.label) {
          debugPrint('Switch encontrado ${sw.label}');
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

  /// Funcion para mostrar como hacer que el switch pueda ser integrado de forma correcta
  /// con el servicio de turno.
  /// Muestra un mensaje de error usando dialog si se produce alguno
  void _showSwitchRequirements(var key) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Recuerda agregar en el servicio la respuesta al switch de la siguinte forma:',
                          style: TextStyle(
                              fontSize:
                                  20 * MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: JsonView.string(
                          '{"res": "true"}',
                          theme:
                              const JsonViewTheme(viewType: JsonViewType.base),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cerrar'),
                      )
                    ]))));
  }
}
