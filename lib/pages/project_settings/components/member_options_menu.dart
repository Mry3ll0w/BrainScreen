import 'package:brainscreen/pages/controllers/project_controller.dart';
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
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  // Estado del Switch
  bool light1 = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: buildOptions(),
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

  Future<Widget> buildOptions() async {
    // Obtenemos si el mail es el propietario
    bool isOwner = await ProjectController.isUserTheOwnerOfProject(
        widget.userMail!, widget.projectName!);
    if (isOwner) {
      return PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry>[
            PopupMenuItem(
              enabled: false,
              child: Row(children: [
                const Text('Cambiar rol'),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Switch(
                    value: light1,
                    thumbIcon: thumbIcon,
                    onChanged: (bool value) {
                      setState(() {
                        light1 = value;
                      });
                    },
                  ),
                ),
              ]),
            ),
          ];
        },
      );
    } else {
      return PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry>[
            PopupMenuItem(
              child: GestureDetector(
                onTap: () {
                  // Realiza la acción de borrar miembro
                  Navigator.pop(context); // Cierra el menú
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
            PopupMenuItem(
              enabled: false,
              child: Row(children: [
                const Text('Cambiar rol'),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Switch(
                    value: light1,
                    thumbIcon: thumbIcon,
                    onChanged: (bool value) {
                      setState(() {
                        light1 = value;
                      });
                    },
                  ),
                ),
              ]),
            ),
          ];
        },
      );
    }
  }
}