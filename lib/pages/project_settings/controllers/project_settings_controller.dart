import 'package:brainscreen/pages/controllers/general_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectSettingsController {
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
      // Si la lista no tiene el propietario, lo añadimos
      if (!members.contains(doc['owner'])) {
        members.add(doc['owner']);
      }
    }

    // Una vez tenemos los uid de los miembros, los convertimos a emails comparandolos con la lista de projects

    List<String> membersMails = [];

    for (var member in members) {
      // Usamos la funcion general getUserMailByUID
      var sMail = await GeneralFunctions.getUserMailByUID(member);
      if (sMail != '') membersMails.add(sMail);
    }

    return membersMails;
  }

  static Future<void> deleteMemberFromProject(
      String projectName, String memberEmail) async {
    // Obtenemos el uid del usuario a partir del email
    String memberUID = await GeneralFunctions.getUserUIDByEmail(memberEmail);
    // En caso de que falle debido a que el email no existe, no hacemos nada
    if (memberUID == '') {
      return;
    } else {
      // Obtenemos el documento del proyecto
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('projects')
          .where('name', isEqualTo: projectName)
          .get();

      // Obtenemos el id del documento
      String docID = query.docs[0].id;

      // Eliminamos el uid del miembro de la lista de miembros
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(docID)
          .update({
        'members': FieldValue.arrayRemove([memberUID])
      });
    }
  }
}
