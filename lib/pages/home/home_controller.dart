import 'package:flutter/material.dart';

class HomeController {
  HomeController._();

  static void projectFetcher(
      String userID, BuildContext context, List<Widget> res) {
    for (int i = 0; i < 5; i++) {
      res.add(ListTile(
        title: Text('Item  $i'),
        onTap: () {
          // Update the state of the app.
          // Then close the drawer.
          Navigator.pop(context);
        },
      ));
    }
  }
}