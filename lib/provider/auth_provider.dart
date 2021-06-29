import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthClass {
  FirebaseAuth auth = FirebaseAuth.instance;
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
    await facebookSignIn.logOut();
    await auth.signOut();
  }

  //Google Auth
  Future<UserCredential> signWithGoogle() async {
    final GoogleSignInAccount googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    User user =
        FirebaseAuth.instance.currentUser; //.signInWithCredential(credential);
  }

  //Facebook
  Future<UserCredential> handleLogin() async {
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

  Future loginWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
