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
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.photoURL),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              user.displayName,
              style: TextStyle(color: Colors.black),
            ),

            // IconButton(
            //   alignment: Alignment.centerRight,
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => Formshowlotto()),
            //       );
            //     },
            //     icon: Icon(Icons.add_business)),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
              size: 35,
            ),
            onPressed: () {},
          ),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.black,
              iconTheme: IconThemeData(color: Colors.black),
              textTheme: TextTheme().apply(bodyColor: Colors.black),
            ),
            child: PopupMenuButton<int>(
              color: Colors.white60,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                
                PopupMenuItem<int>(
                  value: 0,
                  child: Text('Purchase Report',
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
                PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      const SizedBox(width: 8),
                      Text('Sign Out',
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Formshowlotto()),
          );
        },
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

void onSelected(BuildContext context, int item) {
  switch (item) {
    case 0:
    //  Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => Formshowlotto()),
    //       );
      break;
    case 1:
      AuthClass().signOut();
  }
}
