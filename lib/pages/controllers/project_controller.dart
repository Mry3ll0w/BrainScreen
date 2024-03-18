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
      print(doc['name']);
      projects.add(Project(
        doc['name'],
        doc['owner'],
      ));
    }
    return projects;
  }
}
