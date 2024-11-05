import 'package:brainscreen/pages/controllers/project_controller.dart';
import 'package:brainscreen/pages/project_settings/controllers/project_settings_controller.dart';
import 'package:brainscreen/pages/project_settings/views/project_settings.dart';
import 'package:flutter/material.dart';

class MemberOptionsMenu extends StatefulWidget {
  final String? userMail;
  final String? projectName;
  const MemberOptionsMenu(
      {super.key, required this.userMail, required this.projectName});

  @override
  State<MemberOptionsMenu> createState() => _MemberOptionsMenuState();
}

class _MemberOptionsMenuState extends State<MemberOptionsMenu> {
  // Gestor Icons de Switch
  /**
   * final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );
   */

  // Estado del Switch
  bool light1 = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: buildMenuOptions(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const SizedBox(
            width: 50, // Proporciona un ancho
            height: 50, // Proporciona una altura
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<Widget> buildMenuOptions() async {
    // Obtenemos si el mail es el propietario
    bool isOwner = await ProjectController.isUserTheOwnerOfProject(
        widget.userMail!, widget.projectName!);
    bool isEditor = false;

    if (isOwner) {
      return PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry>[
            const PopupMenuItem(
              enabled: false,
              child: Row(children: [
                Text('Dueño del proyecto'),
              ]),
            ),
          ];
        },
      );
    } else {
      // Si no es propietario, mostramos el menú normal
      return PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry>[
            PopupMenuItem(
              child: GestureDetector(
                onTap: () {
                  // Realiza la acción de borrar miembro
                  ProjectSettingsController.deleteMemberFromProject(
                      widget.projectName!, widget.userMail!);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Row(children: [
                  Text('Borrar miembro'),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.delete),
                  ),
                ]),
              ),
            ),
          ];
        },
      );
    }
  }
}
