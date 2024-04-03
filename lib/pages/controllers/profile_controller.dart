import 'general_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController {
  ProfileController._(); //Empty constructor
  final _db = FirebaseFirestore.instance;

  // Vincula la cuenta de Alexa dada con la cuenta de usuario de firebase, en caso de no existir la cuenta de Alexa, se crea
  Future<bool> linkAlexaAccountToUser(String alexaUID) async {
    var linked = true;
    if (alexaUID.isEmpty) {
      linked = false;
    } else {
      try {
        //Link the account
        var firebaseUid = GeneralFunctions.getLoggedUserUID();

        //1) Buscamos si el usuario ya tiene un registro en la coleccion, primero usando el alexaUID
        final alexaUsersRef = _db
            .collection('AlexaUsers')
            .where('amazonUID', isEqualTo: alexaUID);
        QuerySnapshot queryAlexaUIDSearch = await alexaUsersRef.get();
        if (queryAlexaUIDSearch.docs.isNotEmpty) {
          // Si ya existe un registro con ese alexaUID, entonces lo eliminamos
          for (var doc in queryAlexaUIDSearch.docs) {
            // Aunque se usa un for, solo se espera un doc
            await _db
                .collection('AlexaUsers')
                .doc(doc.id)
                .update({'firebaseUID': firebaseUid});
          }
        } else {
          // Dado ese id de amazon no hemos encontrado nada, por lo que buscaremos usan
          final firebaseSearchRef = _db
              .collection('AlexaUsers')
              .where('firebaseUID', isEqualTo: firebaseUid);
          QuerySnapshot queryFirebaseUIDSearch = await firebaseSearchRef.get();
          if (queryFirebaseUIDSearch.docs.isNotEmpty) {
            //Si ya existe un registro con ese firebaseUID, entonces lo eliminamos
            for (var doc in queryFirebaseUIDSearch.docs) {
              // Aunque se usa un for, solo se espera un doc
              await _db
                  .collection('AlexaUsers')
                  .doc(doc.id)
                  .update({'amazonUID': alexaUID});
            }
          } else {
            //Si no existe un registro con ese alexaUID, entonces lo creamos, ya no es necesario verificar si existe un registro con el firebaseUID
            await _db
                .collection('AlexaUsers')
                .add({'amazonUID': alexaUID, 'firebaseUID': firebaseUid});
          }
        }
      } catch (e) {
        linked = false;
      }
    }
    return linked;
  }
}
