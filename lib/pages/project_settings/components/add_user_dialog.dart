import 'package:brainscreen/pages/controllers/project_controller.dart';
import 'package:brainscreen/pages/project_settings/controllers/project_settings_controller.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddUserDialog extends StatefulWidget {
  final String projectName;
  const AddUserDialog({required this.projectName, super.key});
  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  //Needed variables
  String? errorText;
  Future<List<String>> _usersEmails = Future.value([]);
  @override
  void initState() {
    super.initState();
    _usersEmails = ProjectSettingsController.getAllUsersEmail();
  }

  //Users mails to autocomplete

  final user = FirebaseAuth.instance.currentUser;
  String strProjectName = '';
  String strMemberEmail = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom +
            30, // Agrega un valor constante aquí
        left: MediaQuery.of(context).viewInsets.left,
        right: MediaQuery.of(context).viewInsets.right,
        top: MediaQuery.of(context).viewInsets.top,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: FutureBuilder(
                            future: _usersEmails,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<String>.empty();
                                    }
                                    return snapshot.data.where((String option) {
                                      return option.contains(
                                          textEditingValue.text.toLowerCase());
                                    });
                                  },
                                  onSelected: (String selection) {
                                    setState(() {
                                      strMemberEmail = selection;
                                    });
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        fillColor: BrainColors.backgroundColor,
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  BrainColors.mainBannerColor,
                                              width: 2.0),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        labelText: 'Email del nuevo integrante',
                                        helperText:
                                            'El email debe ser el mismo que\nel de la cuenta de google',
                                      ),
                                    );
                                  },
                                );
                              }
                            })),
                    ElevatedButton(
                        onPressed: () => addMember(strMemberEmail),
                        child: const Text('Agregar miembro'))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void checkEmail(String name) {
    //First we check if the name is empty
    if (name.isEmpty) {
      setState(() {
        errorText = 'El nombre del proyecto no puede estar vacío';
      });
    } else if (!name.contains('@')) {
      // No puede tener caracteres especiales ni numericos
      setState(() {
        errorText =
            'Introduzca un correo valido, el email debe ser el mismo que el de la cuenta de google';
      });
    } else {
      setState(() {
        errorText = null;
      });
    }
  }

  //Create the project
  void addMember(String member) async {
    if (errorText != null || widget.projectName == '' || user == null) {
      //Depending on the error or success we show a dialog, if there is an error we show the error.
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Vaya, ha ocurrido un error'),
            content: const Text(
              'Se ha producido un error en la agregación\n'
              'del usuario, espere unos minutos y vuelva\n'
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
      ProjectController.addMemberToProject(widget.projectName, member);
      Navigator.of(context).pop();
    }
  }
}
