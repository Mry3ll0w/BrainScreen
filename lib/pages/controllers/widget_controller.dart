import 'package:brainscreen/pages/models/button_model.dart';
import 'package:brainscreen/pages/models/chart_model.dart';
import 'package:brainscreen/pages/models/field_widget_model.dart';
import 'package:brainscreen/pages/models/slider_model.dart';
import 'package:brainscreen/pages/models/switch_button_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'package:flutter/material.dart';
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
          var setOfButtonLabels = <dynamic>{};

          // Obtenemos todos los labels y lo metemos en lista para agregar el nuevo
          for (var b in setOfButtons) {
            if (b != null) {
              String currentLabel = b['label'];
              setOfButtonLabels.add(currentLabel);
            }
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
        await ref.update({
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
      await ref.update({
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
  static Future<List<dynamic>> fetchAllButtonsFromProject(
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
            elevatedButtonList.add(b);
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

  static Future<List<dynamic>> fetchAllSwitchesRAW(String projectName) async {
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
            if (b['type'] == '1') {
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

  static dynamic fetchAllButtonsRAW(String projectName) async {
    try {
      DatabaseReference refDB =
          FirebaseDatabase.instance.ref().child('lienzo/$projectName/buttons');
      // to read once we use final
      final snapshot = await refDB.get();
      var valueFromSnapshot = snapshot.value;

      //devolvemos la lista con todos los elevatedButtons
      return valueFromSnapshot;
    } catch (e) {
      debugPrint(e.toString());
    }

    return [];
  }

  static Future<List<dynamic>> fetchAllSlidersRAW(String projectName) async {
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
            if (b['type'] == '2') {
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

  /// Agrega un Switch al lienzo del proyecto especificado.
  ///
  /// Esta función escribe datos en la base de datos Firebase Realtime Database
  /// bajo el nodo "lienzo/$sProjectName". Los datos incluyen información básica
  /// como nombre, edad y dirección.
  ///
  /// @param sProjectName El nombre del proyecto al cual se agregará el botón elevado.
  ///        Debe ser una cadena válida y corresponder al nombre de un proyecto existente.
  /// @throws Exception Si ocurre un error al intentar escribir en la base de datos,
  ///        como problemas de permisos o conectividad.
  static void addSwitchToLienzo(String sProjectName) async {
    //obtaining the list of buttons linked to that lienzo
    // 1st we get the db ref
    DatabaseReference refDB =
        FirebaseDatabase.instance.ref().child('lienzo/$sProjectName/buttons');

    // to read once we use final
    final snapshot = await refDB.get();
    Set<dynamic>? setOfSwitches;
    if (snapshot.exists) {
      // Ahora pasamos el valor a set
      var valueFromSnapshot = snapshot.value;
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          setOfSwitches = {...valueFromSnapshot.toSet()};

          // Al tener un set evitamos elementos repetidos, ahora iteramos la lista
          var setOfSwitchLabels = <dynamic>{};

          // Obtenemos todos los labels y lo metemos en lista para agregar el nuevo
          for (var b in setOfSwitches) {
            if (b != null) {
              String currentLabel = b['label'];
              setOfSwitchLabels.add(currentLabel);
            }
          }
          //Usamos la funcion generadora de labels
          String newLabel = randomLabelGenerator(6);
          while (setOfSwitchLabels.contains(newLabel)) {
            newLabel = randomLabelGenerator(6);
          }

          //Una vez tenemos la nueva label creamos la instancia del switch vacio.
          Map<String, dynamic> newSwitch = {
            "label": randomLabelGenerator(6),
            "type": "1",
            "labelText": "Switch",
            "position": "0",
            "baseurl_post": dotenv.env['TESTING_SERVER_URL'],
            "apiurl_post": "/test",
            "payload": {"dato": "valor"},
            "value": "true"
          };

          setOfSwitches.add(newSwitch);

          DatabaseReference ref =
              FirebaseDatabase.instance.ref("lienzo/$sProjectName");

          await ref.update({
            "buttons": setOfSwitches.toList(),
          });
        }
        // Para un mapa, puedes hacer algo como esto:
        // if (valueFromSnapshot is Map<dynamic, dynamic>) {
        //   setOfSwitches = {...valueFromSnapshot.keys.toSet()};
        // }
      } else {
        // Si no es una lista, implica que no existen botones por lo que lo agregamos directamente
        DatabaseReference ref =
            FirebaseDatabase.instance.ref("lienzo/$sProjectName");

        //Updating the button list
        await ref.update({
          "buttons": [
            {
              "label": randomLabelGenerator(6),
              "type": "1",
              "labelText": "Switch",
              "position": "0",
              "baseurl_post": dotenv.env['TESTING_SERVER_URL'],
              "apiurl_post": "/test",
              "payload": {"dato": "valor"},
              "value": "true"
            }
          ],
        });
      }
    } else {
      // Si no es una lista, implica que no existen botones por lo que lo agregamos directamente
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("lienzo/$sProjectName");

      //Updating the button list
      await ref.update({
        "buttons": [
          {
            "label": randomLabelGenerator(6),
            "type": "1",
            "labelText": "Switch",
            "position": "0",
            "baseurl_post": dotenv.env['TESTING_SERVER_URL'],
            "apiurl_post": "/test",
            "payload": {"dato": "valor"},
            "value": "true"
          }
        ]
      });
    }
  }

  static Future<List<SwitchButtonModel>> fetchAllSwitchesFromProject(
      String sProjectName) async {
    List<SwitchButtonModel> lSwitches = [];
    Set<dynamic>? setOfSwitches;
    //Pillamos todos los switches de ese proyecto
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("lienzo/$sProjectName/buttons");
    final snapshot = await ref.get();
    try {
      var valueFromSnapshot = snapshot.value;
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          setOfSwitches = {...valueFromSnapshot.toSet()};

          // Iteramos la lista de switches
          for (var s in setOfSwitches) {
            if (s != null) {
              if (s['type'] == '1') {
                lSwitches.add(SwitchButtonModel(
                    type: s['type'],
                    position: s['position'],
                    label: s['label'],
                    labelText: s['labelText'],
                    baseurlPost: s['baseurl_post'],
                    apiurlPost: s['apiurl_post'],
                    payload: s['payload'],
                    bvalue: bool.parse(s['value'])));
              }
            }
          }

          return lSwitches;
        }
      }
    } catch (e) {
      debugPrint("Error $e");
    }

    return lSwitches;
  }

  /// Devolvera un SwitchModel pq es exactamente igual pero el type es 2
  static Future<List<CustomSliderModel>> fetchAllSlidersFromProject(
      String sProjectName) async {
    List<CustomSliderModel> lSliders = [];
    Set<dynamic>? setOfSwitches;
    //Pillamos todos los switches de ese proyecto
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("lienzo/$sProjectName/buttons");
    final snapshot = await ref.get();
    try {
      var valueFromSnapshot = snapshot.value;
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          setOfSwitches = {...valueFromSnapshot.toSet()};

          // Iteramos la lista de switches
          for (var s in setOfSwitches) {
            if (s['type'] == '2') {
              lSliders.add(CustomSliderModel(
                  type: s['type'],
                  position: s['position'],
                  label: s['label'],
                  labelText: s['labelText'],
                  baseurlPost: s['baseurl_post'],
                  apiurlPost: s['apiurl_post'],
                  payload: s['payload'],
                  dValue: double.parse(s['value'])));
            }
            debugPrint(s.toString());
          }
          return lSliders;
        }
      }
    } catch (e) {
      debugPrint("Error $e");
    }

    return lSliders;
  }

  /// Agrega un Slider al lienzo del proyecto especificado.
  ///
  /// Esta función escribe datos en la base de datos Firebase Realtime Database
  /// bajo el nodo "lienzo/$sProjectName". Los datos incluyen información básica
  /// como nombre, edad y dirección.
  ///
  /// @param sProjectName El nombre del proyecto al cual se agregará el Slider.
  ///        Debe ser una cadena válida y corresponder al nombre de un proyecto existente.
  /// @throws Exception Si ocurre un error al intentar escribir en la base de datos,
  ///        como problemas de permisos o conectividad.
  static void addSliderToLienzo(String sProjectName) async {
    //obtaining the list of buttons linked to that lienzo
    // 1st we get the db ref
    DatabaseReference refDB =
        FirebaseDatabase.instance.ref().child('lienzo/$sProjectName/buttons');

    // to read once we use final
    final snapshot = await refDB.get();
    Set<dynamic>? setOfSliders;
    if (snapshot.exists) {
      // Ahora pasamos el valor a set
      var valueFromSnapshot = snapshot.value;
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          setOfSliders = {...valueFromSnapshot.toSet()};

          // Al tener un set evitamos elementos repetidos, ahora iteramos la lista
          var setOfSliderLabels = <dynamic>{};

          // Obtenemos todos los labels y lo metemos en lista para agregar el nuevo
          for (var b in setOfSliders) {
            if (b != null) {
              String currentLabel = b['label'];
              setOfSliderLabels.add(currentLabel);
            }
          }
          //Usamos la funcion generadora de labels
          String newLabel = randomLabelGenerator(6);
          while (setOfSliderLabels.contains(newLabel)) {
            newLabel = randomLabelGenerator(6);
          }

          //Una vez tenemos la nueva label creamos la instancia del Slider vacio.
          Map<String, dynamic> newSlider = {
            "label": randomLabelGenerator(6),
            "type": "2",
            "labelText": "Slider",
            "position": "0",
            "baseurl_post": dotenv.env['TESTING_SERVER_URL'],
            "apiurl_post": "/test",
            "payload": {"dato": "10"},
            "value": "0"
          };

          setOfSliders.add(newSlider);

          DatabaseReference ref =
              FirebaseDatabase.instance.ref("lienzo/$sProjectName");

          await ref.update({
            "buttons": setOfSliders.toList(),
          });
        }
        // Para un mapa, puedes hacer algo como esto:
        // if (valueFromSnapshot is Map<dynamic, dynamic>) {
        //   setOfSwitches = {...valueFromSnapshot.keys.toSet()};
        // }
      } else {
        // Si no es una lista, implica que no existen botones por lo que lo agregamos directamente
        DatabaseReference ref =
            FirebaseDatabase.instance.ref("lienzo/$sProjectName");

        //Updating the button list
        await ref.update({
          "buttons": [
            {
              "label": randomLabelGenerator(6),
              "type": "2",
              "labelText": "Slider",
              "position": "0",
              "baseurl_post": dotenv.env['TESTING_SERVER_URL'],
              "apiurl_post": "/test",
              "payload": {"dato": "10"},
              "value": "0"
            }
          ],
        });
      }
    } else {
      // Si no es una lista, implica que no existen botones por lo que lo agregamos directamente
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("lienzo/$sProjectName");

      //Updating the button list
      await ref.update({
        "buttons": [
          {
            "label": randomLabelGenerator(6),
            "type": "2",
            "labelText": "Slider",
            "position": "0",
            "baseurl_post": dotenv.env['TESTING_SERVER_URL'],
            "apiurl_post": "/test",
            "payload": {"dato": "10"},
            "value": "0"
          }
        ]
      });
    }
  }

  static Future<int> fetchSliderIndexByLabel(
      String sProjectName, String label) async {
    // Primero buscamos en el lienzo que toque
    var lElevatedButtons =
        await WidgetController.fetchAllButtonsRAW(sProjectName);

    int iPosBtn = 0;
    for (var rawButton in lElevatedButtons) {
      if (label == rawButton['label']) {
        break;
      }
      iPosBtn++;
    }
    return iPosBtn;
  }

  static Future<int> fetchSwitchIndexByLabel(
      String sProjectName, String label) async {
    // Primero buscamos en el lienzo que toque
    var lElevatedButtons =
        await WidgetController.fetchAllButtonsRAW(sProjectName);

    int iPosBtn = 0;
    for (var rawButton in lElevatedButtons) {
      if (label == rawButton['label']) {
        break;
      }
      iPosBtn++;
    }
    return iPosBtn;
  }

  static Future<int> fetchChartIndexByLabel(
      String sProjectName, String label) async {
    // Primero buscamos en el lienzo que toque
    var lElevatedButtons =
        await WidgetController.fetchAllChartsRAW(sProjectName);

    int iPosBtn = 0;
    for (var rawButton in lElevatedButtons) {
      if (label == rawButton['label']) {
        break;
      }
      iPosBtn++;
    }
    return iPosBtn;
  }

  /// Agrega un FieldWidget al lienzo del proyecto especificado.
  ///
  /// Esta función escribe datos en la base de datos Firebase Realtime Database
  /// bajo el nodo "lienzo/$sProjectName/fieldWidgets".
  ///
  /// @param sProjectName El nombre del proyecto al cual se agregará el botón elevado.
  ///        Debe ser una cadena válida y corresponder al nombre de un proyecto existente.
  /// @param FieldWidgetModel fieldwidget, se recibe un modelo preconstruido del widget a agregar al lienzo.
  ///
  /// @throws Exception Si ocurre un error al intentar escribir en la base de datos,
  ///        como problemas de permisos o conectividad.
  static void addFieldWidgetToLienzo(
      String sProjectName, FieldWidgetModel fieldWidget) async {
    //obtaining the list of buttons linked to that lienzo
    // 1st we get the db ref
    DatabaseReference refDB = FirebaseDatabase.instance
        .ref()
        .child('lienzo/$sProjectName/fieldWidgets');

    // to read once we use final
    final snapshot = await refDB.get();
    Set<dynamic>? setOfSwitches;
    if (snapshot.exists) {
      // Ahora pasamos el valor a set
      var valueFromSnapshot = snapshot.value;
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          setOfSwitches = {...valueFromSnapshot.toSet()};

          // Al tener un set evitamos elementos repetidos, ahora iteramos la lista
          var setOfFieldWidgets = <dynamic>{};

          // Obtenemos todos los labels y lo metemos en lista para agregar el nuevo
          for (var b in setOfSwitches) {
            if (b != null) {
              String currentLabel = b['label'];
              setOfFieldWidgets.add(currentLabel);
            }
          }
          //Usamos la funcion generadora de labels
          String newLabel = randomLabelGenerator(6);
          while (setOfFieldWidgets.contains(newLabel)) {
            newLabel = randomLabelGenerator(6);
          }

          //Una vez tenemos la nueva label creamos la instancia del switch vacio.
          Map<String, dynamic> newFieldWidget = {
            "label": randomLabelGenerator(6),
            "labelText": fieldWidget.labelText,
            "baseurl": fieldWidget.baseURL,
            "apiurl": fieldWidget.apiURL_,
            "isNumberField": fieldWidget.bIsNumberField_,
            "value": fieldWidget.widgetValue
          };

          setOfSwitches.add(newFieldWidget);

          DatabaseReference ref =
              FirebaseDatabase.instance.ref("lienzo/$sProjectName");

          await ref.update({
            "fieldWidgets": setOfSwitches.toList(),
          });
        }
        // Para un mapa, puedes hacer algo como esto:
        // if (valueFromSnapshot is Map<dynamic, dynamic>) {
        //   setOfSwitches = {...valueFromSnapshot.keys.toSet()};
        // }
      } else {
        // Si no es una lista, implica que no existen botones por lo que lo agregamos directamente
        DatabaseReference ref =
            FirebaseDatabase.instance.ref("lienzo/$sProjectName");

        //Updating the button list
        await ref.update({
          "fieldWidgets": [
            {
              "label": randomLabelGenerator(6),
              "labelText": fieldWidget.labelText,
              "baseurl": fieldWidget.baseURL,
              "apiurl": fieldWidget.apiURL_,
              "isNumberField": fieldWidget.bIsNumberField_,
              "value": fieldWidget.widgetValue
            }
          ],
        });
      }
    } else {
      // Si no es una lista, implica que no existen botones por lo que lo agregamos directamente
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("lienzo/$sProjectName");

      //Updating the button list
      await ref.update({
        "fieldWidgets": [
          {
            "label": randomLabelGenerator(6),
            "labelText": fieldWidget.labelText,
            "baseurl": fieldWidget.baseURL,
            "apiurl": fieldWidget.apiURL_,
            "isNumberField": fieldWidget.bIsNumberField_,
            "value": fieldWidget.widgetValue
          }
        ]
      });
    }
  }

  /// Se elimina del lienzo el widget con label
  /// @param String projectName => Se proyecto del que se elimina el widget
  /// @param String label => Identificador del widget
  static Future<bool> eraseWidgetFromLienzo(
      String projectName, String label, bool bIsButton) async {
    //Buscamos donde esta segun el tipo de widget
    DatabaseReference ref;

    if (bIsButton) {
      ref =
          FirebaseDatabase.instance.ref().child("lienzo/$projectName/buttons");
    } else {
      ref = FirebaseDatabase.instance
          .ref()
          .child("lienzo/$projectName/fieldWidgets");
    }

    try {
      // to read once we use final
      final snapshot = await ref.get();
      var valueFromSnapshot = snapshot.value;
      int iPosWidget = 0;
      if (valueFromSnapshot != null) {
        // Pasamos a lista y procesamos
        if (valueFromSnapshot is List<dynamic>) {
          // Obtenemos todos los botones elevatedButtons
          for (var b in valueFromSnapshot.toList()) {
            //Buscamos el objecto a eliminar y salimos del bucle cuando lo pillemos
            if (b['label'] == label) {
              break;
            }
            iPosWidget++;
          }
        }

        // Obtenemos la referencia al objeto y la borramos
        DatabaseReference refToErase = bIsButton
            ? FirebaseDatabase.instance
                .ref("lienzo/$projectName/buttons/$iPosWidget")
            : FirebaseDatabase.instance
                .ref("lienzo/$projectName/fieldWidgets/$iPosWidget");

        // Borramos la referencia al objeto
        await refToErase.remove();
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static void genericErrorDialog(
      String sProjectName, var key, var context, String sMsg) {
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
                        padding: const EdgeInsets.all(10.0),
                        child: Text(sMsg),
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

  // Fetch all FieldWidgets as RAW
  static Future<List<dynamic>> fetchAllFieldWidgetsRAW(
      String projectName, bool bIsNumberField) async {
    try {
      DatabaseReference refDB = FirebaseDatabase.instance
          .ref()
          .child('lienzo/$projectName/fieldWidgets');
      // to read once we use final
      final snapshot = await refDB.get();
      var valueFromSnapshot = snapshot.value;
      List<dynamic> fieldWidgets = [];
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          // Obtenemos todos los botones elevatedButtons
          for (var b in valueFromSnapshot.toList()) {
            // Flag para indicar cargar solo NumberFields o solo TextField
            // Si solo quiero numberFields lo pongo a true por lo que solo cojo los q son numberfields
            if (bIsNumberField == b['isNumberField']) {
              fieldWidgets.add(b);
            }
          }
        }
        //devolvemos la lista con todos los fieldWidgets filtrados
        return fieldWidgets;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return [];
  }

  // Funcion para devolver el indice de cada uno de los fieldWidgets dado un projecto y un label
  static Future<int> getFieldWidgetPositionByLabel(
      String sProjectName, String label) async {
    int iPos = 0;
    try {
      DatabaseReference refDB = FirebaseDatabase.instance
          .ref()
          .child('lienzo/$sProjectName/fieldWidgets');
      // to read once we use final
      final snapshot = await refDB.get();
      var valueFromSnapshot = snapshot.value;

      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          // Obtenemos todos los botones elevatedButtons
          for (var b in valueFromSnapshot.toList()) {
            // Flag para indicar cargar solo NumberFields o solo TextField
            // Si solo quiero numberFields lo pongo a true por lo que solo cojo los q son numberfields
            if (label == b['label']) {
              break;
            }
            iPos++;
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      return -1; // Para errores
    }
    return iPos;
  }

  /// Update fieldWidget by sProjectName, fieldWidget y pos, si se producen errores se devuelve false.
  static Future<bool> updateFieldWidgetByModelAndProjectName(
      FieldWidgetModel fw, int index, String sProjectName) async {
    try {
      DatabaseReference refDB = FirebaseDatabase.instance
          .ref()
          .child('lienzo/$sProjectName/fieldWidgets/$index');

      // Updateamos lo recibido
      await refDB.update({
        "label": randomLabelGenerator(6),
        "labelText": fw.labelText,
        "baseurl": fw.baseURL,
        "apiurl": fw.apiURL_,
        "isNumberField": fw.bIsNumberField_,
        "value": fw.widgetValue
      });
      return true;
    } catch (e) {
      debugPrint('SHCE');
      return false;
    }
  }

  static Future<bool> eraseFieldWidgetFromLienzo(
      String projectName, int index) async {
    try {
      DatabaseReference refToErase = FirebaseDatabase.instance
          .ref('lienzo/$projectName/fieldWidgets/$index');

      // Borramos la referencia al objeto
      await refToErase.remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Agrega al lienzo la seccion de graphs
  /// asi como sus elementos
  /// Agrega un FieldWidget al lienzo del proyecto especificado.
  ///
  /// Esta función escribe datos en la base de datos Firebase Realtime Database
  /// bajo el nodo "lienzo/$sProjectName/charts".
  ///
  /// @param sProjectName El nombre del proyecto al cual se agregará el botón elevado.
  ///        Debe ser una cadena válida y corresponder al nombre de un proyecto existente.
  /// @param GraphWidgetModel graph, se recibe un modelo preconstruido del widget a agregar al lienzo.
  ///
  /// @throws Exception Si ocurre un error al intentar escribir en la base de datos,
  ///        como problemas de permisos o conectividad.
  static void addChartToLienzo(String sProjectName, ChartModel chart) async {
    //obtaining the list of buttons linked to that lienzo
    // 1st we get the db ref
    DatabaseReference refDB =
        FirebaseDatabase.instance.ref().child('lienzo/$sProjectName/charts');

    // to read once we use final
    final snapshot = await refDB.get();
    Set<dynamic>? setOfChartsLabels;
    if (snapshot.exists) {
      // Ahora pasamos el valor a set
      var valueFromSnapshot = snapshot.value;
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          setOfChartsLabels = {...valueFromSnapshot.toSet()};

          // Al tener un set evitamos elementos repetidos, ahora iteramos la lista
          var setOfCharts = <dynamic>{};

          // Obtenemos todos los labels y lo metemos en lista para agregar el nuevo
          for (var b in setOfChartsLabels) {
            setOfCharts.add(b);
          }
          //Usamos la funcion generadora de labels
          String newLabel = randomLabelGenerator(6);
          while (setOfCharts.contains(newLabel)) {
            newLabel = randomLabelGenerator(6);
          }

          //Una vez tenemos la nueva label creamos la instancia del switch vacio.
          Map<String, dynamic> newFieldWidget = {
            "label": randomLabelGenerator(6),
            "labelText": chart.labelText,
            "xAxisTitle": chart.sXAxisText,
            "yAxisTitle": chart.sXAxisText,
            "data": {
              "x": [0],
              "y": [0]
            }
          };

          setOfCharts.add(newFieldWidget);

          DatabaseReference ref =
              FirebaseDatabase.instance.ref("lienzo/$sProjectName");

          await ref.update({
            "charts": setOfCharts.toList(),
          });
        }
        // Para un mapa, puedes hacer algo como esto:
        // if (valueFromSnapshot is Map<dynamic, dynamic>) {
        //   setOfCharts = {...valueFromSnapshot.keys.toSet()};
        // }
      } else {
        // Si no es una lista, implica que no existen botones por lo que lo agregamos directamente
        DatabaseReference ref =
            FirebaseDatabase.instance.ref("lienzo/$sProjectName");

        //Updating the button list
        await ref.update({
          "charts": [
            {
              "label": randomLabelGenerator(6),
              "labelText": chart.labelText,
              "xAxisTitle": chart.sXAxisText,
              "yAxisTitle": chart.sXAxisText,
              "data": chart.data
            }
          ],
        });
      }
    } else {
      // Si no es una lista, implica que no existen botones por lo que lo agregamos directamente
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("lienzo/$sProjectName");

      //Updating the button list
      await ref.update({
        "charts": [
          {
            "label": randomLabelGenerator(6),
            "labelText": chart.labelText,
            "xAxisTitle": chart.sXAxisText,
            "yAxisTitle": chart.sXAxisText,
            "data": {
              "x": [0],
              "y": [0]
            }
          }
        ],
      });
    }
  }

  static Future<List<dynamic>> fetchAllChartsRAW(String projectName) async {
    try {
      DatabaseReference refDB =
          FirebaseDatabase.instance.ref().child('lienzo/$projectName/charts');
      // to read once we use final
      final snapshot = await refDB.get();
      var valueFromSnapshot = snapshot.value;
      List<dynamic> charts = [];
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          // Obtenemos todos los botones elevatedButtons
          for (var b in valueFromSnapshot.toList()) {
            // Flag para indicar cargar solo NumberFields o solo TextField
            // Si solo quiero numberFields lo pongo a true por lo que solo cojo los q son numberfields
            charts.add(b);
          }
        }
        //devolvemos la lista con todos los charts filtrados
        return charts;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return [];
  }

  static Future<List<ChartModel>> fetchAllChartsModels(
      String projectName) async {
    try {
      DatabaseReference refDB =
          FirebaseDatabase.instance.ref().child('lienzo/$projectName/charts');
      // to read once we use final
      final snapshot = await refDB.get();
      var valueFromSnapshot = snapshot.value;
      List<ChartModel> charts = [];
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          // Obtenemos todos los botones elevatedButtons
          for (var b in valueFromSnapshot.toList()) {
            charts.add(ChartModel(b['label'], b['labelText'], b['xAxisTitle'],
                b['yAxisTitle'], b['data']));
          }
        }
        //devolvemos la lista con todos los charts filtrados
        return charts;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return [];
  }

  //TODO Funcion Indice chart
  static Future<int> getChartIndex(String projectName, String sLabel) async {
    try {
      DatabaseReference refDB =
          FirebaseDatabase.instance.ref().child('lienzo/$projectName/charts');
      // to read once we use final
      final snapshot = await refDB.get();
      var valueFromSnapshot = snapshot.value;
      int iPos = 0;
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:

        if (valueFromSnapshot is List<dynamic>) {
          // Obtenemos todos los botones elevatedButtons
          for (var b in valueFromSnapshot.toList()) {
            if (b['label'] == sLabel) {
              break;
            }
            iPos++;
          }
        }
        //devolvemos la lista con todos los charts filtrados
        return iPos;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return -1;
  }

  static Future<bool> updateChartByModelAndProjectName(
      ChartModel ch, int index, String sProjectName) async {
    try {
      DatabaseReference refDB = FirebaseDatabase.instance
          .ref()
          .child('lienzo/$sProjectName/charts/$index');

      // Updateamos lo recibido
      await refDB.update({
        "label": randomLabelGenerator(6),
        "labelText": ch.labelText,
        "xAxisTitle": ch.sXAxisText,
        "yAxisTitle": ch.sYAxisText,
        "data": ch.data
      });

      return true;
    } catch (e) {
      debugPrint('SHCE');
      return false;
    }
  }

  static Future<bool> eraseChartFromLienzo(
      String projectName, int indexOfChart) async {
    try {
      DatabaseReference refToErase = FirebaseDatabase.instance
          .ref('lienzo/$projectName/charts/$indexOfChart');

      // Borramos la referencia al objeto
      await refToErase.remove();
      return true;
    } catch (e) {
      return false;
    }
  }
}
