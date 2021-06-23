import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lotto/main.dart';
import 'package:lotto/provider/auth_provider.dart';

class SignUpLoginWidget extends StatefulWidget  {
  @override
  _SignUpLoginWidget createState() => _SignUpLoginWidget();
   
}
class _SignUpLoginWidget extends State<SignUpLoginWidget> {
  FirebaseAuth auth = FirebaseAuth.instance;
  static final FacebookLogin facebookSignIn = new FacebookLogin();
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
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                AuthClass().signWithGoogle().then((UserCredential value) {
                  final displayName = value.user.displayName;

                  print(displayName);

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                      (route) => false);
                });
              },
            ),
            SizedBox(
              height: 60,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: Size(double.infinity, 50)),
              icon: FaIcon(
                FontAwesomeIcons.facebook,
                color: Colors.red,
              ),
              label: Text(" Sign Up with Facebook"),
              onPressed: () {
                handleLogin();
                // AuthClass().handleLogin().then((UserCredential value) {
                //   Navigator.pushAndRemoveUntil(
                //       context,
                //       MaterialPageRoute(builder: (context) => MyHomePage()),
                //       (route) => false);
                // });
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> handleLogin() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          await loginWithfacebook(result);
        } catch (e) {
          print(e);
        }
        break;
    }
  }

bool isSignIn = false;
User _user;
  Future loginWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);
    var a = await FirebaseAuth.instance.signInWithCredential(credential);
    setState(() {
      isSignIn = true;
      _user = a.user;
    });
  }
}
