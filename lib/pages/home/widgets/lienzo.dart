import 'package:brainscreen/pages/home/home_controller.dart';
import 'package:brainscreen/pages/home/widgets/buttons/button_selector.dart';
import 'package:brainscreen/pages/home/widgets/lienzo.components/button_grid.dart';
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
      body: ElementGrid(sProjectName: widget.sProjectName),
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
        icon: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset('img/addWidget.jpeg', width: 80, height: 80),
        ),
        onSelected: (String result) {
          _handleMenuSelection(result);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'button',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text('Botones'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'textfield',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text('Textfield'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'numberfield',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text('Numberfields'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'graph',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text('Gráficas'),
                  ],
                ),
              )
            ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ));
  }

  // Menu Handler
  void _handleMenuSelection(String value) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Container(
            color: BrainColors.backgroundColor,
            child: Column(
              children: [
                Expanded(
                  child: ButtonSelector(
                    sProjectName: widget.sProjectName,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
