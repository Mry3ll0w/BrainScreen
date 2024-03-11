import 'package:brainscreen/pages/home/home_controller.dart';
import 'package:brainscreen/pages/home/widgets/project_creation_dialog.dart';
import 'package:brainscreen/pages/profile/profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> projectList = [];
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    initializeProjectList();
    return Scaffold(
      backgroundColor: const Color(0xFFDCF2F1),
      key: _scaffoldKey, // Assign the key to the Scaffold
      appBar: AppBar(
        title: const Text("Panel de Control"),
        backgroundColor: const Color(0xFF5edce6),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () =>
              _scaffoldKey.currentState?.openDrawer(), // Open the drawer
          tooltip: 'Despliegame!',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 11),
            child: IconButton(
              icon: const Icon(Icons.person_3),
              onPressed: () {
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                }
              }, // Open the drawer
              tooltip: 'Perfil',
            ),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFDCF2F1),
        child: ListView(padding: EdgeInsets.zero, children: projectList),
      ),
      body: chargeToHome(
          projectList.isEmpty ? noProjects() : const Text("Tiene Proyectos")),
      // ... rest of your code
    );
  }

  void initializeProjectList() {
    projectList = <Widget>[
      const SizedBox(
        height: 150,
        child: DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xFF5edce6),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Proyectos',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
      // Add more ListTile widgets here
    ];

    //Now we fetch de projects
    HomeController.projectFetcher('ara', context, projectList);
    //now we Append one more to allow the user the creation of another project
    projectList.add(ListTile(
      onTap: _openCreateProjectButton,
      title: const Row(
        children: [
          Text('Crear nuevo proyecto'),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Icon(Icons.add_circle),
          )
        ],
      ),
    ));
  }

  Widget noProjects() {
    return const Center(
      child: Text('No tienes proyectos, crea uno!'),
    );
  }

  Widget chargeToHome(Widget widgeToLoad) {
    return widgeToLoad;
  }

  void _openCreateProjectButton() {
    showModalBottomSheet(
        context: context, builder: (ctx) => ProjectCreationModal());
  }
}
