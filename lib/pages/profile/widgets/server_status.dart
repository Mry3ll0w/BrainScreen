import 'package:flutter/material.dart';

class ServerStatus extends StatefulWidget {
  const ServerStatus({super.key});

  @override
  State<ServerStatus> createState() => _ServerStatusState();
}

class _ServerStatusState extends State<ServerStatus> {
  late Future<int> futureStatus;

  @override
  void initState() {
    super.initState();
    futureStatus = fetchStatusFromServer();
  }

  Future<int> fetchStatusFromServer() async {
    // Realiza la petición al servidor
    // Este es solo un ejemplo, reemplaza esta línea con tu propia lógica de petición
    await Future.delayed(Duration(seconds: 2)); // Simula un retraso
    return 200; // Simula una respuesta
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: futureStatus,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Column(
            children: [
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text("Comprobando..."),
              ),
            ],
          ); // Muestra un icono de carga mientras la petición está en curso
        } else if (snapshot.hasError) {
          return const Column(
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text("Error, inténtalo de nuevo más tarde."),
              ),
            ],
          ); // Muestra un icono de error si la petición falla
        } else if (snapshot.data == 200) {
          return const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text("El servidor está en línea."),
              ),
            ],
          ); // Muestra un icono de OK si la petición es exitosa
        } else {
          return const Column(
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text("Error inesperado"),
              ),
            ],
          ); // Muestra un icono de error si la petición no es exitosa
        }
      },
    );
  }
}
