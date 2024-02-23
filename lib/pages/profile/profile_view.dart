import 'package:brainscreen/pages/welcome.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, Key? ky});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: BrainColors.mainBannerColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 11.0),
            child: IconButton(
                tooltip: 'Salir de tu cuenta',
                onPressed: () {
                  //Salimos de la cuenta
                  _auth.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeHome()),
                  );
                },
                icon: const Icon(Icons.logout_rounded)),
          )
        ],
      ),
      backgroundColor: BrainColors.backgroundColor,
      body: Center(
        child: Text('User ID: ${_user?.uid}'),
      ),
    );
  }
}
