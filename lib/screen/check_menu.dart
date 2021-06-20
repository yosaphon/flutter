import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'menu_drawer.dart';
import 'menu_notlogin.dart';

class CheckLogInMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return MenuDrawer();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something Went Wrong!'),
              );
            } else {
              return MenuUnknowDrawer();
            }
          },
        ),
      );
}
