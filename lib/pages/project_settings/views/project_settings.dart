import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/pages/project_settings/components/add_user_dialog.dart';
import 'package:brainscreen/pages/project_settings/components/member_options_menu.dart';
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

  late Future<List<String>> _membersFuture;

  @override
  void initState() {
    super.initState();
    _membersFuture =
        ProjectSettingsController.getMembersFromProject(widget.projectName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _membersFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.done) {
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
                                width:
                                    2.0), // Color del borde cuando está habilitado
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
                                width:
                                    2.0), // Color del borde cuando está enfocado
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
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
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: FloatingActionButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.red,
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        const Row(
                                          children: [
                                            Text(
                                                '¿Estás seguro de que querer\neliminar el proyecto?')
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20, left: 40, top: 20),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Llamamos a la función que elimina el proyecto
                                                  // Navegamos a la pantalla principal, borrando todo contexto anterior
                                                  ProjectController
                                                      .eraseProject(
                                                          widget.projectName);
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Home()));
                                                },
                                                child: const Text('Sí'),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('No'),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      )),
                  const Padding(
                      padding: EdgeInsets.only(top: 20), child: Divider()),
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
                      child: ListView.builder(
                        //! Estilar OWNER y agregar icono de eliminar
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (snapshot.data?.length ?? 0) + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // Si el índice es 0, devuelve una ListTile para agregar un usuario
                            return ListTile(
                              title: TextButton(
                                onPressed: () {
                                  // Abre el diálogo para agregar un usuario
                                  AlertDialog dialog = AlertDialog(
                                    title: const Text('Agregar usuario'),
                                    content: AddUserDialog(
                                      projectName: widget.projectName,
                                    ),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return dialog;
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            BrainColors.backgroundButtonColor)),
                                child: const Text('Agregar usuario'),
                              ),
                            );
                          } else {
                            // Si el índice no es 0, devuelve la ListTile para el usuario
                            var user = snapshot.data != null &&
                                    index - 1 < snapshot.data.length
                                ? snapshot.data[index - 1]
                                : null; // Usa index - 1 para obtener el usuario correcto
                            // Comprobamos que el usuario sea el admin del proyecto

                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(user.toString()),
                                trailing: MemberOptionsMenu(
                                  userMail: user.toString(),
                                  projectName: widget.projectName,
                                ),
                              ),
                            );
                          }
                        },
                      )),
                ],
              ),
            ),
          );
        } else {
          return const Text('Error');
        }
      },
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
              title: const Text('¡Proyecto modificado con éxito!'),
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

  // ! AGREGAR FUNCIONALIDAD DE ELIMINAR PROYECTOS.
}
