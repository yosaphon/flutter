import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lotto/api/user_api.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/screen/user/displaylogin.dart';
import 'package:provider/provider.dart';

import 'display_userlotto.dart';

class CheckLogInUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser;
            getUser(userNotifier, user.uid);
            return UserprofileLottery();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Something Went Wrong!'),
            );
          } else {
            return SignUpLoginWidget();
          }
        },
      ),
    );
  }
}
