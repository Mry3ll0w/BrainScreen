import 'package:brainscreen/pages/home/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

    return Text('Proyecto cargado: ${widget.sProjectName}');
  }

  // Initialize required data
  Future<void> initializeData() async {
    // Initialize data

    // Obtenemos el nombre del proyecto
    widget.sProjectName ??=
        await HomeController.getFirstProjectName(widget.user!.uid);
  }
}
