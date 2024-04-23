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
    var QuerySnapshot = await FirebaseFirestore.instance
        .collection('LoggedUsers')
        .where('uid', isEqualTo: uid)
        .get();
    if (QuerySnapshot.docs.isNotEmpty) {
      return QuerySnapshot.docs[0]['email'];
    } else {
      return '';
    }
  }
}
