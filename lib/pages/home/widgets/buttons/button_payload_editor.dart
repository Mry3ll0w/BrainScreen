import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:json_editor/json_editor.dart';

class JsonEditorView extends StatefulWidget {
  String _projectName = '', _label = '';
  dynamic _payload;

  JsonEditorView(
      {super.key,
      required String sProjectName,
      required dynamic payload,
      required String label}) {
    _projectName = sProjectName;
    _payload = payload;
    _label = label;
  }

  @override
  State<JsonEditorView> createState() => _JsonEditorViewState();
}

class _JsonEditorViewState extends State<JsonEditorView> {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
          onPressed: () {
            updatePayload(
                widget._projectName, 'payload', widget._payload, widget.key);
          },
          icon: const Icon(
            Icons.save,
            size: 50,
          )),
      backgroundColor: BrainColors.backgroundButtonColor,
      appBar: AppBar(
        title: const Text('Payload del Widget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: BrainColors.backgroundButtonColor),
            child: JsonEditorTheme(
                themeData: JsonEditorThemeData(
                    darkTheme: JsonTheme.dark(), lightTheme: JsonTheme.light()),
                child: SizedBox(
                  height: 400,
                  child: JsonEditor.object(
                    object: widget._payload,
                    onValueChanged: (value) {
                      widget._payload = value;
                    },
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Future<bool> updatePayload(
      String sProjectName, String field, dynamic newfieldValue, var key) async {
    //Si esta vacio pasamos de hacer nada
    if (newfieldValue != null) {
      // Primero buscamos en el lienzo que toque
      var lElevatedButtons =
          await WidgetController.fetchAllElevatedButtons(sProjectName);

      int iPosBtn = 0;
      for (var rawButton in lElevatedButtons) {
        if (widget._label == rawButton['label']) {
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
                            child: Text(
                                'Error de actualizacion intentelo de nuevo.'),
                          ),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cerrar'),
                          )
                        ]))));
        return false;
      }
    } else {
      return false;
    }
  }
}
