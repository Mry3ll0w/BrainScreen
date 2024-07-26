import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:brainscreen/pages/controllers/widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              isOpen: true,
              contentVerticalPadding: 20,
              leftIcon:
                  const Icon(Icons.text_fields_rounded, color: Colors.white),
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
              isOpen: true,
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
              isOpen: true,
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
    return Text('hola');
  }

  Future<Widget> initializeSwitches() async {
    return Text('Switches');
  }

  Future<Widget> intializeSliders() async {
    return Text('Sliders');
  }
}
