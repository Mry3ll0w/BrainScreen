import 'package:flutter/material.dart';

class WelcomeHome extends StatefulWidget {
  const WelcomeHome({super.key});

  @override
  State<WelcomeHome> createState() => _WelcomeHomeState();
}

class _WelcomeHomeState extends State<WelcomeHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5edce6), //0xFF == #
      appBar: AppBar(
        title: const Center(
          child: Text("BrainScreen"),
        ),
        backgroundColor: const Color(0xFF5edce6),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0.1),
        child: Center(
          child: Column(children: [
            Image.asset('img/logo.jpeg'),
            Padding(
              padding: const EdgeInsets.only(top: 100.0, left: 15, right: 15),
              child: Center(
                  child: Column(children: [
                FilledButton(
                  onPressed: () {},
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 100),
                    child: const Center(
                        child: Text(
                      "Accede",
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                ),
                FilledButton(
                  onPressed: () {},
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 100),
                    child: const Center(
                        child: Text(
                      "¿No tienes cuenta?",
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                )
              ])),
            )
          ]),
        ),
      ),
    );
  }
}
