import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lotto/provider/auth_provider.dart';
import '../main.dart';
import 'formshowlotto.dart';

class UserprofileLottery extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "ผู้ใช้",
            style: TextStyle(color: Colors.black),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          // backgroundColor: Colors.transparent,
          backgroundColor: Colors.black.withOpacity(0.1),
          elevation: 0,
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      height: 64,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(user.photoURL),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(user.displayName),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlueAccent.shade400,
                                onPrimary: Colors.black,
                                minimumSize: Size(double.infinity, 50)),
                            child: Text("เพิ่มสลาก"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Formshowlotto()),
                              );
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                onPrimary: Colors.black,
                                minimumSize: Size(double.infinity, 50)),
                            child: Text("Logout"),
                            onPressed: () {
                              AuthClass().signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()),
                                  (route) => false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
