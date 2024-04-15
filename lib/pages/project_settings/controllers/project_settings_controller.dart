import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjecSettingsController {
  static Future<List<String>> getAllUsersEmail() async {
    List<String> users = [];
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('LoggedUsers')
          .where('uid', isNotEqualTo: currentUser!.uid)
          .get();
      // Metemos todos los usuarios que no son el nuestro en la lista
      for (var doc in querySnapshot.docs) {
        users.add(doc['email']);
      }
    } catch (e) {
      // Handle error if needed
    }
    return users;
  }

  static Future<List<String>> getMembersFromProject(String projectName) async {
    List<String> members = [];
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('projects')
        .where('name', isEqualTo: projectName)
        .get();

    for (var doc in query.docs) {
      members = List<String>.from(doc['members']);
      members.add(doc['owner']);
    }

    // Una vez tenemos los uid de los miembros, los convertimos a emails comparandolos con la lista de projects
    List<String> membersMails = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('LoggedUsers').get();

    for (var doc in querySnapshot.docs) {
      if (members.contains(doc['uid'])) {
        membersMails.add(doc['email']);
      }
    }

    return membersMails;
  }
}
