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
    });
  }

  static Future<List<Project>> getProjectsFromLoggedUser() async {
    List<Project> projects = [];
    QuerySnapshot querySnapshot = await db
        .collection('projects')
        .where('members', arrayContains: _auth.currentUser!.uid)
        .get();
    for (var doc in querySnapshot.docs) {
      projects.add(Project(
        doc['name'],
        doc['owner'],
      ));
    }
    return projects;
  }
}
