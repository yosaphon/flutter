import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lotto/main.dart';
import 'package:lotto/provider/google_sign_in.dart';
import 'package:lotto/screen/check_menu.dart';
import 'package:provider/provider.dart';

import 'display_userlotto.dart';


class SignUpLoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เข้าสู่ระบบ"),
      ),
      drawer: CheckLogInMenu(),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: Size(double.infinity, 50)),
              icon: FaIcon(
                FontAwesomeIcons.google,
                color: Colors.red,
              ),
              label: Text(" Sign Up with Google"),
              onPressed: () {
                final provider = 
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();

                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
              },
            ),
          ],
        ),
      ),
    );
  }
}
