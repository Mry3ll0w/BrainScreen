import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:brainscreen/pages/home/widgets/buttons/button%20listings/slider_setting_list.dart';
import 'package:brainscreen/pages/home/widgets/buttons/button%20listings/switch_setting_list.dart';
import 'package:brainscreen/pages/home/widgets/buttons/buttons_settings.dart';
import 'package:brainscreen/pages/models/button_model.dart';
import 'package:brainscreen/pages/models/field_widget_model.dart';
import 'package:brainscreen/pages/models/switch_button_model.dart';
import 'package:brainscreen/pages/models/slider_model.dart';
import 'package:flutter/material.dart';

class ElementGrid extends StatelessWidget //__
{
  String? projectName_;
  ElementGrid({required sProjectName, super.key}) {
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
              leftIcon: const Icon(
                Icons.bolt_sharp,
                color: Colors.white,
              ),
              rightIcon: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ButtonSettingsList(
                              key: key, sProjectName: projectName_!)));
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
                  const Icon(Icons.commit, color: Colors.white), // ! SLIDERS
              rightIcon: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SliderSettingsList(
                              key: key, sProjectName: projectName_!)));
                },
              ),
              header: const Text('Sliders', style: headerStyle),
              content: FutureBuilder(
                  future: intializeSliders(projectName_!),
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
              leftIcon: const Row(
                children: [
                  Icon(Icons.light_mode, color: Colors.white),
                  Text(
                    '/',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Icon(Icons.light_mode_outlined, color: Colors.white)
                ],
              ),
              rightIcon: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SwitchSettingsList(
                              key: key, sProjectName: projectName_!)));
                },
              ),
              header: const Text('Interruptores', style: headerStyle),
              content: FutureBuilder(
                  future: initializeSwitches(projectName_!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data as Widget;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
            AccordionSection(
              //! Seccion de TextField
              contentVerticalPadding: 20,
              leftIcon: const Row(
                children: [
                  Icon(Icons.translate, color: Colors.white),
                ],
              ),
              rightIcon: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SwitchSettingsList(
                              key: key, sProjectName: projectName_!)));
                },
              ),
              header: const Text('TextFields', style: headerStyle),
              content: FutureBuilder(
                  future: initializeTextFields(projectName_!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data as Widget;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
            AccordionSection(
              //! Seccion de NumberFields
              contentVerticalPadding: 20,
              leftIcon: const Row(
                children: [
                  Icon(Icons.twenty_four_mp, color: Colors.white),
                ],
              ),
              rightIcon: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SwitchSettingsList(
                              key: key, sProjectName: projectName_!)));
                },
              ),
              header: const Text('NumberFields', style: headerStyle),
              content: FutureBuilder(
                  future: initializeNumberFields(projectName_!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data as Widget;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
            AccordionSection(
              //! Seccion de Grafica
              contentVerticalPadding: 20,
              leftIcon: const Row(
                children: [
                  Icon(Icons.auto_graph, color: Colors.white),
                ],
              ),
              rightIcon: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SwitchSettingsList(
                              key: key, sProjectName: projectName_!)));
                },
              ),
              header: const Text('BigData', style: headerStyle),
              content: FutureBuilder(
                  future: initializeSwitches(projectName_!),
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

    if (rows.isEmpty) {
      // Creamos el contenedor que tendrá todas las filas con los botones estilados
      return Container(
        child: Column(
          children: [Text('No hay elementos, agrega uno')],
        ),
      );
    } else {
      // Creamos el contenedor que tendrá todas las filas con los botones estilados
      return Container(
        child: Column(
          children: rows,
        ),
      );
    }
  }

  Future<Widget> initializeSwitches(String sProjectName) async {
    List<SwitchButtonModel> switchList =
        await WidgetController.fetchAllSwitchesFromProject(sProjectName);

    return styledSwitchesModels(switchList);
  }

  Widget styledSwitchesModels(List<SwitchButtonModel> switchList) {
    // Creamos una lista para almacenar las filas (Rows) que contendrán los botones
    List<Widget> rows = [];

    try {
      // Iteramos sobre la lista de botones
      for (SwitchButtonModel s in switchList) {
        // Incrementamos de 2 en 2
        // Creamos una lista temporal para almacenar los botones de cada fila
        List<Widget> switchRow = [];

        // Agregamos hasta dos botones por fila
        switchRow.add(s.buildSwitchWidget(super.key, projectName_!));

        // Creamos una Row con los botones de esta iteración y la agregamos a la lista de filas
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // Distribuye los botones en el espacio disponible
          children: switchRow,
        ));
      }
    } catch (e) {
      rows = [const Text('Se ha producido un error en la lectura del widget')];
    }

    if (rows.isEmpty) {
      // Creamos el contenedor que tendrá todas las filas con los botones estilados
      return Container(
        child: const Column(
          children: [Text('No hay elementos, agrega uno')],
        ),
      );
    } else {
      // Creamos el contenedor que tendrá todas las filas con los botones estilados
      return Container(
        child: Column(
          children: rows,
        ),
      );
    }
  }

  /// Inicializa la lista de sliders
  Future<Widget> intializeSliders(String sProjectName) async {
    List<dynamic> lSliders =
        await WidgetController.fetchAllSlidersFromProject(sProjectName);

    return styledSlidersWidget(lSliders);
  }

  /// Muestra la vista de los sliders
  Widget styledSlidersWidget(List<dynamic> lSliders) {
    // Creamos una lista para almacenar las filas (Rows) que contendrán los botones
    List<Widget> rows = [];

    try {
      // Iteramos sobre la lista de botones
      for (CustomSliderModel sl in lSliders) {
        // Incrementamos de 2 en 2
        // Creamos una lista temporal para almacenar los botones de cada fila
        List<Widget> switchRow = [];

        // Agregamos hasta dos botones por fila
        switchRow.add(sl.buildSliderWidget(super.key, projectName_!));

        // Creamos una Row con los botones de esta iteración y la agregamos a la lista de filas
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // Distribuye los botones en el espacio disponible
          children: switchRow,
        ));
      }
    } catch (e) {
      rows = [const Text('Se ha producido un error en la lectura del widget')];
    }

    if (rows.isEmpty) {
      // Creamos el contenedor que tendrá todas las filas con los botones estilados
      return Container(
        child: const Column(
          children: [Text('No hay elementos, agrega uno')],
        ),
      );
    } else {
      // Creamos el contenedor que tendrá todas las filas con los botones estilados
      return Container(
        child: Column(
          children: rows,
        ),
      );
    }
  }

  // ! Seccion de inicializacion de Textfields
  //??TODO IMPLEMENTAR BACKEND
  Future<Widget> initializeTextFields(String sProjectName) async {
    // Pillamos los textFields
    List<dynamic> lTextFields =
        await WidgetController.fetchAllFieldWidgetsRAW(sProjectName, false);

    return styledTextFieldsModels(lTextFields);
  }

  Widget styledTextFieldsModels(List<dynamic> lFieldWidgets) {
    // Creamos una lista para almacenar las filas (Rows) que contendrán los botones
    List<Widget> rows = [];

    try {
      // Iteramos sobre la lista de botones
      int iPos = 0;
      for (var fw in lFieldWidgets) {
        // Incrementamos de 2 en 2
        // Creamos una lista temporal para almacenar los botones de cada fila
        List<Widget> switchRow = [];

        // Agregamos hasta dos botones por fila
        switchRow.add(FieldWidgetView(
            fieldwidget: FieldWidgetModel(
                apiURL: fw['apiurl'],
                labelText: fw['labelText'],
                label: fw['label'],
                baseURL: fw['baseurl'],
                widgetValue: fw['value'],
                numberField: fw['isNumberField']),
            sprojectName: projectName_!,
            pos: iPos));

        // Creamos una Row con los botones de esta iteración y la agregamos a la lista de filas
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // Distribuye los botones en el espacio disponible
          children: switchRow,
        ));
        iPos++;
      }
    } catch (e) {
      rows = [const Text('Se ha producido un error en la lectura del widget')];
    }

    if (rows.isEmpty) {
      // Creamos el contenedor que tendrá todas las filas con los botones estilados
      return Container(
        child: const Column(
          children: [Text('No hay elementos, agrega uno')],
        ),
      );
    } else {
      // Creamos el contenedor que tendrá todas las filas con los botones estilados
      return Container(
        child: Column(
          children: rows,
        ),
      );
    }
  }

  // ! Seccion de inicializacion de Numberfields
  //??TODO IMPLEMENTAR BACKEND
  Future<Widget> initializeNumberFields(String sProjectName) async {
    List<SwitchButtonModel> switchList =
        await WidgetController.fetchAllSwitchesFromProject(sProjectName);

    return styledSwitchesModels(switchList);
  }

  Widget styledNumberFieldsModels(List<SwitchButtonModel> switchList) {
    // Creamos una lista para almacenar las filas (Rows) que contendrán los botones
    List<Widget> rows = [];

    try {
      // Iteramos sobre la lista de botones
      for (SwitchButtonModel s in switchList) {
        // Incrementamos de 2 en 2
        // Creamos una lista temporal para almacenar los botones de cada fila
        List<Widget> switchRow = [];

        // Agregamos hasta dos botones por fila
        switchRow.add(s.buildSwitchWidget(super.key, projectName_!));

        // Creamos una Row con los botones de esta iteración y la agregamos a la lista de filas
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // Distribuye los botones en el espacio disponible
          children: switchRow,
        ));
      }
    } catch (e) {
      rows = [const Text('Se ha producido un error en la lectura del widget')];
    }

    if (rows.isEmpty) {
      // Creamos el contenedor que tendrá todas las filas con los botones estilados
      return Container(
        child: const Column(
          children: [Text('No hay elementos, agrega uno')],
        ),
      );
    } else {
      // Creamos el contenedor que tendrá todas las filas con los botones estilados
      return Container(
        child: Column(
          children: rows,
        ),
      );
    }
  }
}
