import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lotto/api/user_api.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/provider/auth_provider.dart';
import 'package:lotto/screen/purchase_report.dart';
import 'package:lotto/screen/userlotteryDetail.dart';
import 'package:lotto/widgets/paddingStyle.dart';
import 'package:lotto/widgets/searchWidget.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'formshowlotto.dart';

class UserprofileLottery extends StatefulWidget {
  @override
  _UserprofileLotteryState createState() => _UserprofileLotteryState();
}

class _UserprofileLotteryState extends State<UserprofileLottery> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController _searchController = TextEditingController();
  int selectedindex = 0;
  int selectedindexsecond = 0;
  List<UserData> lottos = [];
  String number, query = '';
  _DisplayScreenState paddingStyle;
  void initiateSearch(String val) {
    setState(() {
      number = val.toLowerCase().trim();
    });
  }

  @override
  void initState() {
    //loadData();
    super.initState();
  }

  Future loadData(userNotifier) async {
    await getUser(userNotifier, user.uid);

    lottos = userNotifier.currentUser;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    //var size = MediaQuery.of(context).size;

    void searchLotto(String query) {
      final lottos = userNotifier.currentUser.where((lotto) {
        final lNumber = lotto.number;
        return lNumber.contains(query);
      }).toList();

      setState(() {
        this.query = query;
        this.lottos = lottos;
      });
    }

    Widget buildSearch() => SearchWidget(
          text: query,
          hintText: 'เลข',
          onChanged: searchLotto,
        );
    Widget buildLotto(UserData lotto, String docID) {
      return ListTile(
        tileColor: Colors.white54,
        leading: lotto.imageurl != null
            ? Image.network(
                lotto.imageurl,
                width: 100,
                fit: BoxFit.fitWidth,
              )
            : Image.asset(
                'asset/guraLottery.png',
                width: 50,
                fit: BoxFit.fitWidth,
              ), //ต้องแก้เป็นรูปที่บันทึก ตอนนี้เอามาแสดงไว้ก่อน
        title: Row(
          children: [
            Text(
              lotto.number,
              style: TextStyle(color: Colors.indigo),
            ),
            Padding(        
              padding: const EdgeInsets.only(left:16.0),
              child: Text(
                "${lotto.date}",
                style: TextStyle(color: Colors.black, fontSize: 14 ),
              ),
            ),
          ],
        ),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: "จำนวน ",
                style: TextStyle(color: Colors.black, fontFamily: "Mitr")),
            TextSpan(
                text: lotto.amount,
                style: TextStyle(color: Colors.orange, fontFamily: "Mitr")),
            TextSpan(
                text: " ใบ",
                style: TextStyle(color: Colors.black, fontFamily: "Mitr"))
          ])),
          RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: "ราคา ",
                style: TextStyle(color: Colors.black, fontFamily: "Mitr")),
            TextSpan(
                text: lotto.lotteryprice,
                style: TextStyle(color: Colors.orange, fontFamily: "Mitr")),
            TextSpan(
                text: " บาท",
                style: TextStyle(color: Colors.black, fontFamily: "Mitr"))
          ]))
        ]),
        trailing: IconButton(
          icon: lotto.state == true
              ? Icon(
                  Icons.check_circle,
                  color: Colors.lightGreenAccent,
                )
              : lotto.state == false
                  ? Icon(
                      Icons.cancel,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.circle,
                      color: Colors.white54,
                    ),
          onPressed: () {},
        ),
        onTap: () async {
          //กดเพื่อดูรายละเอียด
          var docid = docID;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Formshowdetaillotto(docid: docid, userID: user.uid)),
          );
        },
        onLongPress: () {
          //แก้ไข
          // var docid = document.id;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => FormUpdatelotto(
          //             docid: docid,
          //           )),
          // );

          // // กดเพื่อลบ
          confirmDialog(context, docID, lotto.imageurl, user.uid);

          // deleteUserLottery(document.id);
          // FirebaseFirestore.instance.collection('userlottery').doc(document.id).delete();
          // Navigator.pop(context);
        },
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Color(0xFFF3FFFE),
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
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.black54,
              iconTheme: IconThemeData(color: Colors.black54),
              textTheme: TextTheme().apply(bodyColor: Colors.black54),
            ),
            child: PopupMenuButton<int>(
              color: Colors.white70,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text('Purchase Report',
                      style: TextStyle(color: Colors.black54)),
                ),
                PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      const SizedBox(width: 8),
                      Text('Sign Out', style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: (query.isEmpty || userNotifier.currentUser.isEmpty)
            ? loadData(userNotifier)
            : null,
        builder: (context, AsyncSnapshot snapshot) {
          if (userNotifier.currentUser.isEmpty) {
            return Center(
              child: Text("สามารถเพิ่มสลากเข้าสู้ระบบโดยกดปุ่มเพิ่ม"),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSearch(),
              Expanded(
                child: ListView.builder(
                  itemCount: lottos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final lotto = lottos[index];

                    return frameWidget(
                        buildLotto(lotto, userNotifier.docID[index]));
                  },
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: Column(
        children: [
          Spacer(),
          FloatingActionButton.extended(
            heroTag: "btn1",
            onPressed: () async {
              List<String> date1 = [];
              userNotifier.currentUser.forEach((element) {
                date1.add(element.date);
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PurchaseReportfilter(
                          userdate: date1.toSet().toList(),
                        )),
              );
            },
            //upsdat

            icon: Icon(Icons.feed),
            label: const Text(
              'ดูรายงาน',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
          SizedBox(
            height: 15,
          ),
          FloatingActionButton.extended(
            heroTag: "btn2",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Formshowlotto()),
              );
            },
            icon: Icon(Icons.add),
            label: const Text(
              'เพิ่มข้อมูล',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.amber,
          ),
          FloatingActionButton.extended(
            heroTag: "btn3",
            tooltip: 'Increment',
            elevation: 0,
            splashColor: Colors.transparent,
            onPressed: () async {},
            label: Opacity(
              opacity: 0,
            ),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void changeIndexfirst(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  void changeIndexsecon(int index) {
    setState(() {
      selectedindexsecond = index;
    });
  }

  Widget textcutom(String data) {
    return Text(
      data,
      style: TextStyle(color: Colors.blue, fontSize: 20),
    );
  }
}

class _DisplayScreenState {}

Future<Null> confirmDialog(
    BuildContext context, String documentId, String imageurl, String userID) {
  UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);

  return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('คุณต้องการลบสลากใช่หรือไม่'),
          actions: <Widget>[
            new TextButton(
              child: Container(
                width: 60.0,
                child: Text('ลบข้อมูล',
                    style: TextStyle(fontSize: 16, color: Colors.red)),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                if (imageurl != null) {
                  deleteImage(imageurl);
                }
                await FirebaseFirestore.instance
                    .collection('userlottery')
                    .doc(documentId)
                    .delete();
              },
            ),
            SizedBox(
              width: 20,
            ),
            new TextButton(
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

Future<void> deleteImage(String imageFileUrl) async {
  var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
      .replaceAll(new RegExp(r'(\?alt).*'), '');

  final firebase_storage.Reference firebaseStorageRef =
      firebase_storage.FirebaseStorage.instance.ref().child(fileUrl);
  await firebaseStorageRef.delete();
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
