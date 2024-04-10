import 'package:brainscreen/pages/home/home_controller.dart';
import 'package:brainscreen/pages/home/widgets/project_creation_dialog.dart';
import 'package:brainscreen/pages/profile/profile_view.dart';
import 'package:brainscreen/styles/brain_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final Widget? childrenView;
  final String? title;

  // Constructor para Home con nombre variable
  const Home.named({
    this.childrenView,
    required this.title,
    super.key,
  });

  //Predefinido
  const Home({
    this.childrenView,
    super.key,
  }) : title = 'BrainScreen';

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
        title: Text(widget.title ?? 'BrainScreen'),
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
              icon: const Icon(Icons.account_tree_outlined),
              onPressed: () {
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
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
      body: chargeToHome(widget
          .childrenView), // ! El elemeto a cargar es el 1er proyecto q tengas
      // ... rest of your code
    );
  }

  void initializeProjectList() {
    final user = FirebaseAuth.instance.currentUser;
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
    HomeController.projectFetcher(user!.uid, context, projectList);
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

  Widget chargeToHome(Widget? widgeToLoad) {
    if (widgeToLoad != null) {
      return widgeToLoad;
    } else {
      if (projectList.length == 0) {
        // ! RECUERDA CAMBIAR A > 1 para q funcione
        return const Center(
          child: Text('Selecciona un proyecto para comenzar'),
        );
      } else {
        return Center(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 100,
              child: ClipOval(
                child: Image.asset('img/no_projects_icon.jpeg'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
                decoration: BoxDecoration(
                  color: BrainColors.backgroundButtonColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Para crear tu lienzo, primero necesitarás un proyecto.\nPulsa en :',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 30),
                        child: Center(
                            child: Icon(
                          Icons.menu,
                          size: 50,
                        ))),
                  ],
                )),
          )
        ]));
      }
    }
  }

  void _openCreateProjectButton() {
    showModalBottomSheet(
        context: context, builder: (ctx) => const ProjectCreationModal());
  }
}
