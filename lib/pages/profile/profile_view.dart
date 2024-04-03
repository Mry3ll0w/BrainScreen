import 'package:brainscreen/pages/welcome.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

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
                Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      children: <Widget>[
                        TextButton(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.0, bottom: 15),
                                      child: Text('Guia de uso'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      width: 300,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Text(
                                          'Para la configuración de tu proyecto, tienes que agregar al cuerpo de tu petición el siguiente código:'),
                                    ),
                                    Container(
                                      height: 300,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: JsonView.string(
                                        '{"UID": "${_user.uid}"}',
                                        theme: const JsonViewTheme(
                                            viewType: JsonViewType.base),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cerrar'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: BrainColors.backgroundButtonColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Configura tu proyecto',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Icon(Icons.arrow_forward_ios),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
              ]),
            ),
            Container()
          ],
        ),
      )),
    );
  }
}
