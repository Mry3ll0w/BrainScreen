import 'package:brainscreen/pages/controllers/general_functions.dart';
import 'package:brainscreen/pages/controllers/http_controller.dart';
import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ButtonSelector extends StatefulWidget {
  //Required Elements
  String? sProjectName;

  //Ctor de Clase para guardar project
  ButtonSelector({required this.sProjectName, super.key}) {
    sProjectName = sProjectName;
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  State<ButtonSelector> createState() => _ButtonSelectorState();
}

class _ButtonSelectorState extends State<ButtonSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Botones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 150,
              height: 75,
              child: ElevatedButton(
                onPressed: () {
                  showButtonInfoDialog('ada');
                },
                child: const Text('Pulsame'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showButtonInfoDialog(String value) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Card.outlined(
              color: BrainColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15), // Redondea las esquinas
              ),
              elevation: 4, // Altura de la sombra
              margin: EdgeInsets.all(20), // Margen alrededor del Card
              child: Container(
                color: BrainColors.backgroundColor,
                child: getElevatedButtonInfo(),
              ),
            ),
          );
        });
  }

  // Widget para mostrar la informacion de cada uno de los botones
  Widget getElevatedButtonInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ListTile(
          leading: Icon(Icons.help_center),
          title: Text('Uso'),
          subtitle: Text(
              'Envio ordenes al proyecto, interactuando unidireccionalmente mediante mensajes HTTP.'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const SizedBox(width: 8),
            TextButton(
              child: FittedBox(
                child: Text('Agregar a ${widget.sProjectName!}'),
              ),
              onPressed: () {
                // TODO: Agregar funcionalidad de insertar boton en el lienzo.
                //WidgetController.addElevatedButtonToLienzo(
                //    widget.sProjectName!);
                HttpRequestsController.put(
                    dotenv.env['TESTING_SERVER_URL']!,
                    '/test',
                    {'data': 'Hola desde flutter'},
                    GeneralFunctions.getLoggedUserUID(),
                    '');
                /* //! RECUERDA DESCOMENTAR PARA QUE FUNCIONE COMO DEBE
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home.named(
                            title: widget.sProjectName,
                            projectToLoad: widget.sProjectName)));*/
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }
}
