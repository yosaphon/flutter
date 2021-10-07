import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.height*0.5,
          
               decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF63C4F).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 0,
                    offset: Offset(7, 7), // changes position of shadow
                  ),
                  
                ],
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(26))),
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text("เข้าสู่ระบบ",style: TextStyle(color: Color(0xFFF63C4F),fontSize: 25),),
                      ),
                      GoogleAuthButton(
                          style: AuthButtonStyle(
                            borderRadius: 20,
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
                        padding: const EdgeInsets.all(7.0),
                        child: Text("หรือ",style: TextStyle(color: Colors.black54,fontSize: 16),),
                      ),
                      FacebookAuthButton(
                        style: AuthButtonStyle(
                            borderRadius: 20,
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
                        AuthClass().signInWithFacebook().then((UserCredential value) {
                        });
                      }),
                    ],
                  ),
                
            ),
          Positioned(
            
            top: -180,
            bottom: 200,
            left: 100,
            child: Image.asset('asset/guraLottery.png',width: 140,)),]),
        ),
      ),
    );
  }
}
