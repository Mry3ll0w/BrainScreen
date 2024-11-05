import 'package:brainscreen/pages/controllers/project_controller.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/pages/models/project_model.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectCreationModal extends StatefulWidget {
  const ProjectCreationModal({super.key});
  @override
  State<ProjectCreationModal> createState() => _ProjectCreationModalState();
}

class _ProjectCreationModalState extends State<ProjectCreationModal> {
  //Needed variables
  String? errorText;
  final user = FirebaseAuth.instance.currentUser;
  String strProjectName = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text("Datos del Proyecto",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                      onChanged: (value) => {
                            checkProjectName(value),
                            setState(() {
                              strProjectName = value;
                            })
                          },
                      style: const TextStyle(fontStyle: FontStyle.italic),
                      decoration: InputDecoration(
                        errorText: errorText,
                        fillColor: BrainColors.backgroundColor,
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width:
                                  2.0), // Color del borde cuando está habilitado
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: BrainColors.mainBannerColor,
                              width:
                                  2.0), // Color del borde cuando está enfocado
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'Nombre del Proyecto',
                        helperText:
                            'No puede tener caracteres especiales\nni números',
                      )),
                ),
                ElevatedButton(
                    onPressed: createProject,
                    child: const Text('Crear proyecto'))
              ],
            )),
      ],
    );
  }

  void checkProjectName(String name) {
    //First we check if the name is empty
    if (name.isEmpty) {
      setState(() {
        errorText = 'El nombre del proyecto no puede estar vacío';
      });
    } else if (!name.contains(RegExp(r'^[a-zA-Z ]+$'))) {
      // No puede tener caracteres especiales ni numericos
      setState(() {
        errorText =
            'El nombre del proyecto no puede tener caracteres\nespeciales ni números ';
      });
    } else {
      //If not empty now we check if the name is already taken
      ProjectController.getProjectsFromLoggedUser().then((value) {
        for (var proyect in value) {
          if (proyect.name == name) {
            setState(() {
              errorText = 'El nombre del proyecto ya está en uso';
            });
            break;
          } else {
            setState(() {
              errorText = null;
            });
          }
        }
      });
    }
  }

  //Create the project
  Future<void> createProject() {
    if (errorText != null || strProjectName == '' || user == null) {
      //Depending on the error or success we show a dialog, if there is an error we show the error.
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Vaya, ha ocurrido un error'),
            content: const Text(
              'Se ha producido un error en la creación\n'
              'del proyecto, espere unos minutos y vuelva\n'
              'a intentarlo, si persiste contacte con \n'
              'antonio.roldanandrade@alum.uca.es',
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    } else {
      ProjectController.createProyect(Project(strProjectName, user!.uid));
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('¡Proyecto creado con éxito!'),
            content: const Text(
              'Su proyecto se ha registrado con éxito\n'
              'puedes comenzar cuando quieras 💻 \n',
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                },
              )
            ],
          );
        },
      );
    }
  }
}
