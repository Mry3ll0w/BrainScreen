import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralFunctions {
  GeneralFunctions._();

  static final _auth = FirebaseAuth.instance;
  static final _user = FirebaseAuth.instance.currentUser;

  //Get if current user logged
  static bool isUserLogged() {
    return _user != null;
  }

  // Pillamos el UID del usuario logueado
  static getLoggedUserUID() {
    return _user!.uid;
  }

  static Future<String> getUserMailByUID(String uid) async {
    // Obtenemos los datos del usuario Logged usando el UID dado
    var querySnapshot = await FirebaseFirestore.instance
        .collection('LoggedUsers')
        .where('uid', isEqualTo: uid)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0]['email'];
    } else {
      return '';
    }
  }

  static Future<String> getUserUIDByEmail(String email) async {
    // Obtenemos los datos del usuario Logged usando el email dado
    var querySnapshot = await FirebaseFirestore.instance
        .collection('LoggedUsers')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0]['uid'];
    } else {
      return '';
    }
  }
}
