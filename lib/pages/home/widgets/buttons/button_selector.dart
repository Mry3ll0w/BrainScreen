import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/homeView.dart';
import 'package:brainscreen/pages/models/slider_model.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  bool bSwitch = true;
  double _currentSliderValue = 20;
  @override
  Widget build(BuildContext context) {
    //Screen Size
    final ScreenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Botones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    height: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        _showButtonInfoDialog();
                      },
                      child: const Text('Pulsame'),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 75,
                    child: Switch(
                      value: bSwitch,
                      onChanged: (value) {
                        setState(() {
                          bSwitch = value;
                        });
                        _showSwitchInfoDialog();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  SizedBox(
                      width: ScreenSize.width - 80,
                      height: 75,
                      child: CustomSlider(
                        onLongPressed: () {
                          //TODO Implemnt onLongPress
                        },
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showButtonInfoDialog() {
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

  void _showSwitchInfoDialog() {
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
                child: _getSwitchInfo(context),
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
                WidgetController.addElevatedButtonToLienzo(
                    widget.sProjectName!);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home.named(
                            title: widget.sProjectName,
                            projectToLoad: widget.sProjectName)));
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  // Widget para mostrar la informacion de cada uno de los botones
  Widget _getSwitchInfo(var context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.help_center),
          title: const Text('Uso'),
          subtitle: Text(
            'Recibo el estado de una variable booleana y cambio su estado, encendido u apagado.',
            style: TextStyle(
              fontSize: 20 *
                  MediaQuery.of(context).size.width /
                  360, // Ajusta el tamaño de la fuente basado en el ancho de la pantalla
            ),
          ),
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
                WidgetController.addSwitchToLienzo(widget.sProjectName!);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home.named(
                            title: widget.sProjectName,
                            projectToLoad: widget.sProjectName)));
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }
}
