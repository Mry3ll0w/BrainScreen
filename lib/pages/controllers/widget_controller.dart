import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("lienzo/$sProjectName");
    //obtaining the list of buttons linked to that lienzo
    // 1st we get the db ref
    DatabaseReference _refDB =
        FirebaseDatabase.instance.ref().child('lienzo/$sProjectName/buttons');

    // to read once we use final
    final snapshot = await _refDB.get();
    Set<dynamic>? setOfButtons;
    if (snapshot.exists) {
      // Ahora pasamos el valor a set
      var valueFromSnapshot = snapshot.value;
      if (valueFromSnapshot != null) {
        // Suponiendo que valueFromSnapshot es una lista o un mapa que quieres convertir a un Set
        // Para una lista, puedes hacer algo como esto:
        if (valueFromSnapshot is List<dynamic>) {
          setOfButtons = {...valueFromSnapshot.toSet()};
        }
        // Para un mapa, puedes hacer algo como esto:
        // if (valueFromSnapshot is Map<dynamic, dynamic>) {
        //   setOfButtons = {...valueFromSnapshot.keys.toSet()};
        // }
      }
      // TODO: AGREGAR EL BOTON A LA LISTA Y CREAR TODA LA INFRAESTRUCTURA
      //Updating the button list
      await ref.set({
        "buttons": ['prueba', 'pepe'],
      });
    } else {
      print("LECTURA INCORRECTA");
    }
/*
    {
        "buttons": [],
        "graphs": [],
        "textFields": [],
        "numberFields": [],
        "sliders": [],
        "text": []
    }
*/
  }
}
