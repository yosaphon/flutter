import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotto/screen/check_menu.dart';


class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("หน้าแรก")),
      drawer: CheckLogInMenu(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("lottery").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data.docs.map((document) {
                return Container(
                  child: ListTile(
                    leading: FittedBox(
                      child: Text(document["date"]),
                    ),
                    title: Text(document["prizes"]),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
