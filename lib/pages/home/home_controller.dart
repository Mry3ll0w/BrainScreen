import 'package:brainscreen/pages/controllers/project_controller.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/pages/profile/profile_view.dart';
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
                                proyectName: proyect.name,
                              ),
                              title: 'Ajustes',
                            )), // Replace NewView with the class of your new view
                  );
                },
              ),
            ],
          ),
          onTap: () {
            // Update the state of the app.
            // Then close the drawer.
            Navigator.pop(context);
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
}
