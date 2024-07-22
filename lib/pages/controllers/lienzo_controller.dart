import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LienzoController {
  final user = FirebaseAuth.instance.currentUser;
  FirebaseDatabase rtDatabase = FirebaseDatabase.instance;

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
  static void initializeLienzo(String sProjectName) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("lienzo/$sProjectName");
    await ref.set({
      "buttons": {},
      "graphs": {},
      "textFields": {},
      "numberFields": {},
      "sliders": {},
      "text": {}
    });
  }
}
