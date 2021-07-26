import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lotto/model/userlottery.dart';
import 'package:lotto/provider/auth_provider.dart';
import '../main.dart';
import 'formshowlotto.dart';

class UserprofileLottery extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: false,
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
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
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
              color: Colors.white70,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text('Purchase Report',
                      style: TextStyle(color: Colors.black)),
                ),
                PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      const SizedBox(width: 8),
                      Text('Sign Out', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("userlottery")
            .where('userid', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data.docs.map((document) {
              return Card(
                child: ListTile(
                  // tileColor: Colors.cyan[100],
                  leading: Image.network(
                    user.photoURL,
                    width: 100,
                    fit: BoxFit.fitWidth,
                  ), //ต้องแก้เป็นรูปที่บันทึก ตอนนี้เอามาแสดงไว้ก่อน
                  title: Text(document["number"]),
                  subtitle: Text("จำนวน " +
                      document["amount"] +
                      " ใบ   " +
                      document["lotteryprice"] +
                      " บาท"),
                  trailing: IconButton(
                    // สามารถปรับทำว่าถถ้าตรวจแล้วเป็น ถูกถ้ายังเป็น x
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () async {
                    //กดเพื่อดูรายละเอียด
                  },
                  onLongPress: () {
                    // กดเพื่อลบ
                    confirmDialog(context, document.id);

                    // deleteUserLottery(document.id);
                    // FirebaseFirestore.instance.collection('userlottery').doc(document.id).delete();
                    // Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
          );
        },
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

Future<Null> confirmDialog(BuildContext context, String documentId) {
  return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('คุณต้องการลบสลากใช่หรือไม่'),
          actions: <Widget>[
            new FlatButton(
              child: Container(
                width: 60.0,
                child: Text('ลบข้อมูล',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red
                        )),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                FirebaseFirestore.instance
                    .collection('userlottery')
                    .doc(documentId)
                    .delete();
              },
            ),
            SizedBox(width: 20,),
            new FlatButton(
              child: Container(
                width: 60.0,
                child: Text('ยกเลิก',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        backgroundColor: Colors.white70)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
