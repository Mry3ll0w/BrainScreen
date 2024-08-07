import 'package:brainscreen/pages/models/button_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WidgetController {
  final user = FirebaseAuth.instance.currentUser;

  /// Agrega un botón elevado al lienzo del proyecto especificado.
  ///
  /// Esta función escribe datos en la base de datos Firebase Realtime Database
  /// bajo el nodo "lienzo/$sProjectName". Los datos incluyen información básica
  /// como nombre, edad y dirección.
  ///
  /// @param sProjectName El nombre del proyecto al cual se agregará el botón elevado.
  ///        Debe ser una cadena válida y corresponder al nombre de un proyecto existente.
  /// @throws Exception Si ocurre un error al intentar escribir en la base de datos,
  ///        como problemas de permisos o conectividad.
  static void addElevatedButtonToLienzo(String sProjectName) async {
    //obtaining the list of buttons linked to that lienzo
    // 1st we get the db ref
    DatabaseReference refDB =
        FirebaseDatabase.instance.ref().child('lienzo/$sProjectName/buttons');

    // to read once we use final
    final snapshot = await refDB.get();
    Set<dynamic>? setOfButtons;
    if (snapshot.exists) {
      // Ahora pasamos el valor a set
      var valueFromSnapshot = snapshot.value;
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          setOfButtons = {...valueFromSnapshot.toSet()};

          // Al tener un set evitamos elementos repetidos, ahora iteramos la lista
          var setOfButtonLabels = Set();

          // Obtenemos todos los labels y lo metemos en lista para agregar el nuevo
          for (var b in setOfButtons) {
            String currentLabel = b['label'];
            setOfButtonLabels.add(currentLabel);
          }
          //Usamos la funcion generadora de labels
          String newLabel = randomLabelGenerator(6);
          while (setOfButtonLabels.contains(newLabel)) {
            newLabel = randomLabelGenerator(6);
          }

          //Una vez tenemos la nueva label creamos la instancia del boton vacio.
          Map<String, dynamic> newButton = {
            "label": newLabel,
            "type": "0",
            "labelText": "Boton",
            "position": "0",
            "petition": "POST",
            "baseurl": dotenv.env['TESTING_SERVER_URL'],
            "apiurl": "/test",
            "payload": {"dato": "valor"}
          };

          setOfButtons.add(newButton);

          DatabaseReference ref =
              FirebaseDatabase.instance.ref("lienzo/$sProjectName");

          await ref.update({
            "buttons": setOfButtons.toList(),
          });
        }
        // Para un mapa, puedes hacer algo como esto:
        // if (valueFromSnapshot is Map<dynamic, dynamic>) {
        //   setOfButtons = {...valueFromSnapshot.keys.toSet()};
        // }
      } else {
        // Si no es una lista, implica que no existen botones por lo que lo agregamos directamente
        DatabaseReference ref =
            FirebaseDatabase.instance.ref("lienzo/$sProjectName");

        //Updating the button list
        await ref.set({
          "buttons": [
            {
              "label": randomLabelGenerator(6),
              "type": "0",
              "labelText": "Boton",
              "position": "0",
              "petition": "POST",
              "baseurl": dotenv.env['TESTING_SERVER_URL'],
              "apiurl": "/test",
              "payload": {"dato": "valor"}
            }
          ],
        });
      }
    } else {
      // Si no es una lista, implica que no existen botones por lo que lo agregamos directamente
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("lienzo/$sProjectName");

      //Updating the button list
      await ref.set({
        "buttons": [
          {
            "label": randomLabelGenerator(6),
            "type": "0",
            "labelText": "Boton",
            "position": "0",
            "petition": "POST",
            "baseurl": dotenv.env['TESTING_SERVER_URL'],
            "apiurl": "/test",
            "payload": {"dato": "valor"}
          }
        ],
      });
    }
  }

  /// Devuelve una cadena aleatoria de caracteres para usar labels
  /// @returns String
  static String randomLabelGenerator(int longitud) {
    const caracteres =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      longitud,
      (_) => caracteres.codeUnitAt(random.nextInt(caracteres.length)),
    ));
  }

  /// Devuelve todos los botones de un lienzo de tipo elevatedButtons
  /// @returns List<Map<String,String>>
  static Future<List<dynamic>> fetchAllElevatedButtons(
      String projectName) async {
    try {
      DatabaseReference refDB =
          FirebaseDatabase.instance.ref().child('lienzo/$projectName/buttons');
      // to read once we use final
      final snapshot = await refDB.get();
      var valueFromSnapshot = snapshot.value;
      List<dynamic> elevatedButtonList = [];
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          // Obtenemos todos los botones elevatedButtons
          for (var b in valueFromSnapshot.toList()) {
            //ElevatedButton
            if (b['type'] == '0') {
              elevatedButtonList.add(b);
            }
          }
        }
        //devolvemos la lista con todos los elevatedButtons
        return elevatedButtonList;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return [];
  }

  /// Pasa la lista de Dynamic a lista de ElevatedButtons

  static Future<List<ElevatedButtonModel>> fetchElevatedButtonsModels(
      String projectName) async {
    List<ElevatedButtonModel> lElevatedButtonsModels = [];

    List<dynamic> lRawElevatedButtons =
        await fetchAllElevatedButtons(projectName);

    for (var button in lRawElevatedButtons) {
      lElevatedButtonsModels.add(ElevatedButtonModel(
          label: button['label'],
          labelText: button['labelText'],
          type: button['type'],
          petition: button['petition'],
          baseURL: button['baseurl'],
          apiURL: button['apiurl'],
          payload: button['payload']));
    }

    return lElevatedButtonsModels;
  }
}
