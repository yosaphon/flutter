import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lotto/main.dart';
import 'package:lotto/provider/auth_provider.dart';

class SignUpLoginWidget extends StatefulWidget {
  @override
  _SignUpLoginWidget createState() => _SignUpLoginWidget();
}

class _SignUpLoginWidget extends State<SignUpLoginWidget> {
  FirebaseAuth auth = FirebaseAuth.instance;
  // static final FacebookLogin facebookSignIn = new FacebookLogin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "เข้าสู่ระบบ",
          style: TextStyle(color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 60 ,right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            GoogleAuthButton(
                style: AuthButtonStyle(
                  borderRadius: 8,
                  width: 280,
                  height: 50,
                  iconSize: 35,
                  separator: 10.0,
                  padding: const EdgeInsets.all(8.0),
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.50,
                  ),
                ),
                onPressed: () {
                  AuthClass().signWithGoogle().then((UserCredential value) {
                  });
                }),
            SizedBox(
              height: 40,
            ),
            FacebookAuthButton(
              style: AuthButtonStyle(
                  borderRadius: 8,
                  width: 280,
                  height: 50,
                  iconSize: 35,
                  separator: 10.0,
                  padding: const EdgeInsets.all(8.0),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.50,
                  ),
                ),
              onPressed: () {
              AuthClass().handleLogin().then((UserCredential value) {
              });
            }),
          ],
        ),
      ),
    );
  }
}
