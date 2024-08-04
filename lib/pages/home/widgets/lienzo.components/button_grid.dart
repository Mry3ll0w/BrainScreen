import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/widgets/buttons/buttons_settings.dart';
import 'package:brainscreen/pages/models/button_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ButtonGrid extends StatelessWidget //__
{
  String? projectName_;
  ButtonGrid({required sProjectName, super.key}) {
    projectName_ = sProjectName;
  }
  static const headerStyle = TextStyle(
      color: Color(0xffffffff), fontSize: 18, fontWeight: FontWeight.bold);
  static const contentStyleHeader = TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  static const contentStyle = TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  static const loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';
  static const slogan =
      'Do not forget to play around with all sorts of colors, backgrounds, borders, etc.';

  @override
  build(context) => Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          title: const Text('Botonera'),
        ),
        body: Accordion(
          headerBorderColor: Colors.blueGrey,
          headerBorderColorOpened: Colors.transparent,
          // headerBorderWidth: 1,
          headerBackgroundColorOpened: Colors.green,
          contentBackgroundColor: Colors.white,
          contentBorderColor: Colors.green,
          contentBorderWidth: 3,
          contentHorizontalPadding: 20,
          scaleWhenAnimating: true,
          openAndCloseAnimation: true,
          headerPadding:
              const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
          sectionClosingHapticFeedback: SectionHapticFeedback.light,
          children: [
            AccordionSection(
              contentVerticalPadding: 20,
              rightIcon: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ButtonSettings(
                                key: super.key,
                                sProjectName: projectName_!,
                              )));
                },
              ),
              header: const Text('Pulsadores', style: headerStyle),
              content: FutureBuilder(
                  future: initializeElevatedButtons(projectName_!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data as Widget;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
            AccordionSection(
              contentVerticalPadding: 20,
              leftIcon:
                  const Icon(Icons.text_fields_rounded, color: Colors.white),
              header: const Text('Sliders', style: headerStyle),
              content: FutureBuilder(
                  future: intializeSliders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data as Widget;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
            AccordionSection(
              contentVerticalPadding: 20,
              leftIcon:
                  const Icon(Icons.text_fields_rounded, color: Colors.white),
              header: const Text('Interruptores', style: headerStyle),
              content: FutureBuilder(
                  future: initializeSwitches(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data as Widget;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            )
          ],
        ),
      );

  /// Funcion encargada de cargar los botones asociados a ese lienzo
  Future<Widget> initializeElevatedButtons(String projectName) async {
    List<dynamic> buttonList =
        await WidgetController.fetchAllElevatedButtons(projectName);

    for (var b in buttonList) {
      debugPrint(b['label']);
    }

    //Devolvemos un row

    return styledElevatedButtonsWidget(buttonList);
  }

  Widget styledElevatedButtonsWidget(List<dynamic> buttonList) {
    // Creamos una lista para almacenar las filas (Rows) que contendrán los botones
    List<Widget> rows = [];

    try {
      // Iteramos sobre la lista de botones
      for (int i = 0; i < buttonList.length; i += 2) {
        // Incrementamos de 2 en 2
        // Creamos una lista temporal para almacenar los botones de cada fila
        List<Widget> buttonRow = [];
        // Agregamos hasta dos botones por fila
        for (int j = i; j < i + 2 && j < buttonList.length; j++) {
          // Creamos el Modelo del boton
          print(buttonList[j].toString());
          var b = ElevatedButtonModel(
              label: buttonList[j]['label'],
              labelText: buttonList[j]['labelText'],
              type: buttonList[j]['type'],
              petition: buttonList[j]['petition'],
              baseURL: buttonList[j]['baseurl'],
              apiURL: buttonList[j]['apiurl'],
              payload: buttonList[j]['payload']);
          // Aquí puedes personalizar el estilo del botón según tus necesidades
          buttonRow.add(b.buildElevatedButtonWidget(projectName_!,
                  b.labelText_) // Suponiendo que buttonList contiene Strings
              );
        }

        // Creamos una Row con los botones de esta iteración y la agregamos a la lista de filas
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // Distribuye los botones en el espacio disponible
          children: buttonRow,
        ));
      }
    } catch (e) {
      rows = [const Text('Se ha producido un error en la lectura del widget')];
    }

    // Creamos el contenedor que tendrá todas las filas con los botones estilados
    Container c = Container(
      child: Column(
        children: rows,
      ),
    );

    return c;
  }

  Future<Widget> initializeSwitches() async {
    return Text('Switches');
  }

  Future<Widget> intializeSliders() async {
    return Text('Sliders');
  }
}
