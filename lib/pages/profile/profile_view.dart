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

  var sName = '';

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
          child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_user!.photoURL!),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      sName = value;
                    });
                  },
                  style: const TextStyle(fontStyle: FontStyle.italic),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        _user.updateDisplayName(sName);
                      },
                    ),
                    // Remove the fillColor property
                    // fillColor: BrainColors.backgroundColor,
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0), // Color del borde cuando está habilitado
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: BrainColors.mainBannerColor,
                          width: 2.0), // Color del borde cuando está enfocado
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: _user.displayName ?? 'Sin nombre en google',
                    hintText: 'Usuario',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: TextField(
                    enabled: false,
                    onChanged: (value) {
                      setState(() {
                        sName = value;
                      });
                    },
                    style: const TextStyle(fontStyle: FontStyle.italic),
                    decoration: InputDecoration(
                      // Remove the fillColor property
                      // fillColor: BrainColors.backgroundColor,
                      filled: true,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width:
                                2.0), // Color del borde cuando está habilitado
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: BrainColors.mainBannerColor,
                            width: 2.0), // Color del borde cuando está enfocado
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: _user.email ?? 'Sin mail vinculado',
                      hintText: 'Mail Vinculado, no editable',
                    ),
                  ),
                )
              ]),
            ),
            Container()
          ],
        ),
      )),
    );
  }
}
