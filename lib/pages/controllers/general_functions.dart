import 'package:firebase_auth/firebase_auth.dart';

class GeneralFunctions {
  GeneralFunctions._();

  static final _auth = FirebaseAuth.instance;
  static final _user = FirebaseAuth.instance.currentUser;

  //Get if current user logged
  static bool isUserLogged() {
    return _user != null;
  }
}
