import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeHome extends StatefulWidget {
  const WelcomeHome({super.key});

  @override
  State<WelcomeHome> createState() => _WelcomeHomeState();
}

class _WelcomeHomeState extends State<WelcomeHome>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
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
        body: _user != null ? userInfo() : notLogged());
  }

  Widget notLogged() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.1),
      child: Center(
        child: Column(children: [
          Image.asset('img/logo.jpeg'),
          Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 15, right: 15),
            child: Center(
                child: Column(children: [
              FilledButton(
                onPressed: () {
                  handleGoogleSignIn();
                },
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
    );
  }

  Widget userInfo() {
    return Scaffold(
      body: MaterialButton(
        onPressed: _auth.signOut,
        child: Text("Cerrar Sesion"),
      ),
    );
  }

  void handleGoogleSignIn() {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(googleAuthProvider);
    } catch (e) {
      print(e);
    }
  }
}
