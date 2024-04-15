import 'package:brainscreen/pages/project_settings/controllers/project_settings_controller.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:flutter/material.dart';
import 'package:brainscreen/pages/controllers/project_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectSettings extends StatefulWidget {
  final String projectName;
  const ProjectSettings({super.key, required this.projectName});

  @override
  State<ProjectSettings> createState() => _ProjectSettingsState();
}

class _ProjectSettingsState extends State<ProjectSettings> {
  String? strErrorTextNameField;

  String strProjectName = '';
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(
                child: Text(
                  'Nombre del Proyecto',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: TextField(
                style: const TextStyle(fontStyle: FontStyle.italic),
                decoration: InputDecoration(
                    fillColor: BrainColors.backgroundColor,
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0), // Color del borde cuando está habilitado
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        changeProjectName();
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: BrainColors.mainBannerColor,
                          width: 2.0), // Color del borde cuando está enfocado
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: widget.projectName,
                    hintText:
                        'Recuerda, el nombre del proyecto no puede tener numeros',
                    errorText: strErrorTextNameField),
                onChanged: (value) => {
                  checkProjectName(value),
                  setState(() {
                    strProjectName = value;
                  })
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(
                child: Text(
                  'Participantes',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: FutureBuilder(
                  future: ProjecSettingsController.getMembersFromProject(
                      widget.projectName),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // Si el índice es 0, devuelve una ListTile que dice "Agregar usuario"
                            return ListTile(
                              title: TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            BrainColors.backgroundButtonColor)),
                                child: const Text('Agregar usuario'),
                              ),
                            );
                          } else {
                            // Si el índice no es 0, devuelve la ListTile para el usuario
                            var user = snapshot.data[index -
                                1]; // Usa index - 1 para obtener el usuario correcto
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(user.toString()),
                                trailing: IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {},
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  void checkProjectName(String name) {
    //First we check if the name is empty
    if (name.isEmpty) {
      setState(() {
        strErrorTextNameField = 'El nombre del proyecto no puede estar vacío';
      });
    } else if (!name.contains(RegExp(r'^[a-zA-Z ]+$'))) {
      // No puede tener caracteres especiales ni numericos
      setState(() {
        strErrorTextNameField =
            'El nombre del proyecto no puede tener caracteres\nespeciales ni números ';
      });
    } else {
      //If not empty now we check if the name is already taken
      ProjectController.getProjectsFromLoggedUser().then((value) {
        for (var proyect in value) {
          if (proyect.name == name) {
            setState(() {
              strErrorTextNameField = 'El nombre del proyecto ya está en uso';
            });
            break;
          } else {
            setState(() {
              strErrorTextNameField = null;
            });
          }
        }
      });
    }
  }

  Future<void> changeProjectName() async {
    if (strErrorTextNameField != null || strProjectName == '' || user == null) {
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
      final String resolution =
          await ProjectController.changeCurrentUserProjectName(
              widget.projectName, strProjectName);
      if (resolution == 'ok') {
        return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('¡Proyecto creado con éxito!'),
              content: const Text(
                'Se ha cambiado el nombre \n'
                'puedes continuar cuando quieras.\n',
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
        return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('¡Se ha producido un error!'),
              content: Text(resolution),
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
      }
    }
  }
}
