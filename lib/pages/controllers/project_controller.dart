import 'package:brainscreen/pages/models/project_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectController {
  static final db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static void createProyect(Project p) {
    db.collection('projects').add({
      'name': p.name,
      'owner': _auth.currentUser!.uid,
      'members': [p.ownerUID],
      'alexaUserID': ''
    });
  }

  static Future<List<Project>> getProjectsFromLoggedUser() async {
    List<Project> projects = [];
    List<QueryDocumentSnapshot> proyectos = [];
    //Get the projects where the user is a member or the owner
    // Consulta para proyectos donde el usuario es miembro
    QuerySnapshot queryMiembros = await db
        .collection('projects')
        .where('members', arrayContains: _auth.currentUser!.uid)
        .get();
    proyectos.addAll(queryMiembros.docs);
    // Consulta para proyectos donde el usuario es propietario
    QuerySnapshot queryPropietarios = await db
        .collection('projects')
        .where('owner', isEqualTo: _auth.currentUser!.uid)
        .get();

    //Agregamos los proyectos que no esten ya en la lista de proyectos usando su nombre de proyecto
    for (var doc in queryPropietarios.docs) {
      if (!proyectos.any((element) => element['name'] == doc['name'])) {
        proyectos.add(doc);
      }
    }

    for (var doc in proyectos) {
      projects.add(Project(
        doc['name'],
        doc['owner'],
      ));
    }
    return projects;
  }

  // Dado el nombre de un proyecto, devuelve la lista de miembros (propietario y participantes)
  static Future<List<String>> getMembersFromProject(String projectName) async {
    List<String> members = [];
    QuerySnapshot query = await db
        .collection('projects')
        .where('name', isEqualTo: projectName)
        .get();
    for (var doc in query.docs) {
      members = List<String>.from(doc['members']);
      members.add(doc['owner']);
    }
    return members;
  }

  static Future<String> changeCurrentUserProjectName(
      String strProjectName, String newName) async {
    String sResult = 'ok';
    // Comprobamos si el usuario es propietario del proyecto o esta en la lista de miembros
    QuerySnapshot queryOwner = await db
        .collection('projects')
        .where('owner', isEqualTo: _auth.currentUser!.uid)
        .where('name', isEqualTo: strProjectName)
        .get();

    if (queryOwner.docs.isEmpty) {
      QuerySnapshot queryMember = await db
          .collection('projects')
          .where('members', arrayContains: _auth.currentUser!.uid)
          .where('name', isEqualTo: strProjectName)
          .get();
      if (queryMember.docs.isEmpty) {
        sResult = 'No tienes permisos para cambiar el nombre de este proyecto';
      } else {
        // Pertenece a la lista de miembros, por lo que actualizamos el nombre
        db
            .collection('projects')
            .doc(queryMember.docs[0].id)
            .update({'name': newName});
      }
    } else {
      // Pertenece al usuario, por lo que actualizamos el nombre
      db
          .collection('projects')
          .doc(queryOwner.docs[0].id)
          .update({'name': newName});
    }

    // Devolvemos el resultado de la operacion
    return sResult;
  }

  static void addMemberToProject(String strProjectName, String sMail) async {
    if (strProjectName == '' || sMail == '') {
      return;
    } else {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('LoggedUsers')
          .where('email', isEqualTo: sMail)
          .get();
      if (querySnapshot.docs.isEmpty) {
        print('No existe el usuario');
        return;
      } else {
        // Usamos las QuerySnapshot para obtener el uid del usuario
        String sUID = querySnapshot.docs[0].id;
        // Metemos ese uid en la lista de miembros del proyecto, en caso de que no este ya en miembros u owner
        QuerySnapshot queryOwner = await db
            .collection('projects')
            .where('owner', isEqualTo: _auth.currentUser!.uid)
            .where('name', isEqualTo: strProjectName)
            .get();
        // Si no es propietario, comprobamos si es miembro
        if (queryOwner.docs.isEmpty) {
          QuerySnapshot queryMember = await db
              .collection('projects')
              .where('members', arrayContains: _auth.currentUser!.uid)
              .where('name', isEqualTo: strProjectName)
              .get();
          if (queryMember.docs.isEmpty) {
            print('No tienes permisos para añadir miembros a este proyecto');
          } else {
            // Pertenece a la lista de miembros, por lo que actualizamos el nombre
            db.collection('projects').doc(queryMember.docs[0].id).update({
              'members': FieldValue.arrayUnion([sUID])
            });
          }
        } else {
          // Pertenece al usuario, por lo que actualizamos el nombre
          db.collection('projects').doc(queryOwner.docs[0].id).update({
            'members': FieldValue.arrayUnion([sUID])
          });
        }
      }
    }
  }
}
