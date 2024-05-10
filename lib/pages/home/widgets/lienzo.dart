import 'package:brainscreen/pages/home/home_controller.dart';
import 'package:brainscreen/pages/home/widgets/lienzo.components/widget_grid.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Lienzo extends StatefulWidget {
  //Required Elements
  String? sProjectName;
  final user = FirebaseAuth.instance.currentUser;

  Lienzo({super.key}) {
    // Se carga el primer proyecto de forma predeterminada
  }
  Lienzo.named({super.key, required this.sProjectName});

  @override
  State<Lienzo> createState() => _LienzoState();
}

class _LienzoState extends State<Lienzo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadProjectsWidgets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data as Widget;
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  // Cargamos el primer proyecto
  Future<Widget> loadProjectsWidgets() async {
    // Inicializamos los datos requeridos
    await initializeData();

    return Scaffold(
      floatingActionButton: _widgetInsertionMenu(),
      backgroundColor: BrainColors.backgroundColor,
      body: WidgetGrid(),
    );
  }

  // Initialize required data
  Future<void> initializeData() async {
    // Initialize data

    // Obtenemos el nombre del proyecto
    widget.sProjectName ??=
        await HomeController.getFirstProjectName(widget.user!.uid);
  }

  Widget _widgetInsertionMenu() {
    return PopupMenuButton<String>(
        icon: const Icon(
          Icons.app_registration_outlined,
          size: 50,
        ),
        onSelected: (String result) {
          // Aquí puedes manejar la selección del menú
          print('Has seleccionado: $result');
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Opción 1',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text('Botones'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Opción 2',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text('Textfield'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Opción 2',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text('Numberfields'),
                  ],
                ),
              )
            ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ));
  }
}
