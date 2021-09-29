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
      extendBodyBehindAppBar: false,
      backgroundColor: Color(0xFFF3FFFE),
      body: Container(
        padding: EdgeInsets.only(left: 30 ,right: 30),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height*0.3,
            width: MediaQuery.of(context).size.height*0.5,

             decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 4), // changes position of shadow
                ),
              ],
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text("เข้าสู่ระบบ",style: TextStyle(color: Colors.indigo,fontSize: 25),),
                    ),
                    GoogleAuthButton(
                        style: AuthButtonStyle(
                          borderRadius: 8,
                          width: 250,
                          height: 40,
                          iconSize: 35,
                          separator: 10.0,
                          padding: const EdgeInsets.all(8.0),
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.50,
                          ),
                        ),
                        onPressed: () {
                          AuthClass().signWithGoogle().then((UserCredential value) {
                          });
                        }),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("หรือ",style: TextStyle(color: Colors.indigo,fontSize: 16),),
                    ),
                    FacebookAuthButton(
                      style: AuthButtonStyle(
                          borderRadius: 8,
                          width: 250,
                          height: 40,
                          iconSize: 35,
                          separator: 10.0,
                          padding: const EdgeInsets.all(8.0),
                          textStyle: const TextStyle(
                            fontSize: 16,
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
        ),
      ),
    );
  }
}
