import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel de Control"),
        backgroundColor: const Color(0xFF5edce6),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
          tooltip: 'Despliegame!',
        ),
      ),
      body: MaterialButton(
        onPressed: auth.signOut,
        child: const Text("Cerrar Sesion"),
      ),
    );
  }
}
