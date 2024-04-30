import 'package:brainscreen/pages/controllers/general_functions.dart';
import 'package:brainscreen/pages/controllers/project_controller.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/pages/home/widgets/lienzo.dart';
import 'package:brainscreen/pages/project_settings/views/project_settings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController {
  HomeController._();

  //Documntacion de la funcion
  ///This function fetches the proyects of the user and adds them to the list
  static void projectFetcher(
      String userID, BuildContext context, List<Widget> res) {
    //We fetch the proyects using the project controller
    ProjectController.getProjectsFromLoggedUser().then((value) {
      //We add the proyects to the list
      for (var proyect in value) {
        res.add(ListTile(
          title: Row(
            children: <Widget>[
              Text(proyect.name),
              IconButton(
                icon: const Icon(
                    Icons.settings), // Cambia esto por el icono que quieras
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home.named(
                              childrenView: ProjectSettings(
                                projectName: proyect.name,
                              ),
                              title: 'Ajustes',
                              projectToLoad: proyect.name,
                            )), // Replace NewView with the class of your new view
                  );
                },
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home.named(
                          childrenView: Lienzo.named(
                            sProjectName: proyect.name,
                          ),
                          title: proyect.name,
                          projectToLoad: proyect.name,
                        )));
          },
        ));
      }
    });
  }

  //function to fetch if the user has any proyects
  static Future<bool> hasProyects(String userUID) async {
    //We fetch the proyects
    bool hasProyects = false;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('proyects')
        .get();

    //We check if the user has any proyects

    hasProyects = querySnapshot.docs.isNotEmpty;
    return hasProyects;
  }

  static void createProyect(
    String userUID,
    String proyectName,
    BuildContext context,
    List<Widget> res,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('proyects')
          .doc(proyectName)
          .set({
        'name': proyectName,
        'creation_date': DateTime.now(),
        'delete_date': '',
        'members': [userUID],
      });
      //Now we refresh the list of proyects
      res.clear(); //Reset the list
      projectFetcher(userUID, context, res);
    } catch (e) {
      Dialog(
        child: Text('Error: $e'),
      );
    }
  }

  // Funcion para bypasear el tener q pagar firebase admin features

  static void registerCurrentUserIfNotCreated(
      String userID, String userMail) async {
    // Check if the user is already registered
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('LoggedUsers')
        .where('uid', isEqualTo: userID)
        .where('email', isEqualTo: userMail)
        .get();

    // Si no existe el usuario lo creamos, en otro caso no hacemos nada
    if (querySnapshot.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('LoggedUsers').add({
        'uid': userID,
        'email': userMail,
      });
    }
  }

  // Get the first project of the Logged User
  static Future<String> getFirstProjectName(String userID) async {
    //We fetch the proyects
    String sProjectName = '';
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Obtenemos los proyectos donde el usuario es el propietario
    final QuerySnapshot ownerSnapshot = await firestore
        .collection('projects')
        .where('owner', isEqualTo: userID)
        .get();

// Obtenemos los proyectos donde el usuario es un miembro
    final QuerySnapshot memberSnapshot = await firestore
        .collection('projects')
        .where('members', arrayContains: userID)
        .get();

// Combinamos los resultados
    final List<DocumentSnapshot> projects = [
      ...ownerSnapshot.docs,
      ...memberSnapshot.docs
    ];
    // Pillamos el primer resultado
    if (projects.isNotEmpty) {
      sProjectName = projects.first.get('name');
    }
    return sProjectName;
  }
}
