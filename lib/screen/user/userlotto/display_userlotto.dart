import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lotto/api/user_api.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/notifier/sumary_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/provider/auth_provider.dart';
import 'package:lotto/screen/user/sumary/purchaseShow.dart';
import 'package:lotto/screen/user/sumary/purchase_report.dart';
import 'package:lotto/screen/user/add/userlotteryDetail.dart';
import 'package:lotto/widgets/paddingStyle.dart';
import 'package:lotto/widgets/searchWidget.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import '../add/formshowlotto.dart';

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
  List<String> docID = [];
  String number, query = '';
  bool stateCheck = false;
  _DisplayScreenState paddingStyle;

  ScrollController _scrollController =
      new ScrollController(); // set controller on scrolling
  bool _show = true;

  void initiateSearch(String val) {
    setState(() {
      number = val.toLowerCase().trim();
    });
  }

  @override
  void initState() {
    //loadData();
    handleScroll();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }

  Future loadData(
      UserNotifier userNotifier, UserSumaryNotifier userSumaryNotifier) async {
    await getUser(userNotifier, user.uid,
        userSumaryNotifier: userSumaryNotifier);

    lottos = userNotifier.keyCurrentUser.values.toList();
    docID = userNotifier.keyCurrentUser.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    UserSumaryNotifier userSumaryNotifier =
        Provider.of<UserSumaryNotifier>(context, listen: false);
    docID = userNotifier.keyCurrentUser.keys.toList();
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
          hintText: 'ค้นหาเลข',
          onChanged: searchLotto,
        );
    String getKeyByValue(Map<String,UserData> curr, UserData userData) {
      return curr.keys.firstWhere((k) => curr[k] == userData, orElse: () => null);
    }

    Widget buildLotto(UserData lotto, String docID) {
      return ListTile(
        tileColor: Colors.white54,
        leading: lotto.imageurl != null
            ? Image.network(
                lotto.imageurl,
                width: 50,
                height: 50,
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
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Text(
                "${numToWord(lotto.date)}",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.6),
                child: lotto.state == true
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
                            Icons.hourglass_bottom,
                            color: Color(0xFFB3B7C0),
                          ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "ราคา ",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Mitr")),
                      TextSpan(
                          text: lotto.lotteryprice,
                          style: TextStyle(
                              color: Colors.orange, fontFamily: "Mitr")),
                      TextSpan(
                          text: " บาท",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Mitr")),
                    ])),
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "  จำนวน ",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Mitr")),
                      TextSpan(
                          text: lotto.amount,
                          style: TextStyle(
                              color: Colors.orange, fontFamily: "Mitr")),
                      TextSpan(
                          text: " ใบ",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Mitr"))
                    ])),
                    Spacer(),
                  ],
                ),
              ),
            ]),
          ],
        ),
        onTap: () async {
          //กดเพื่อดูรายละเอียด
          String docid = docID;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Formshowdetaillotto(
                    userID: userNotifier.keyCurrentUser[docid].userid,
                    docID: docid)),
          );
        },
        onLongPress: () {
          confirmDialog(context, docID, lotto.imageurl, user.uid);
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
              style: TextStyle(color: Colors.white),
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
              dividerColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme().apply(bodyColor: Colors.white),
            ),
            child: PopupMenuButton<int>(
              color: Colors.white,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 8),
                      Text('Sign Out',
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Mitr")),
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
            ? loadData(userNotifier, userSumaryNotifier)
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
                child: Container(
                    constraints: BoxConstraints(
                      minHeight: 3000,
                      // maxHeight: 200, //minimum height
                    ),
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        ...lottos.map((e) {
                          UserData lotto = e;
                          return frameWidget(buildLotto(lotto, getKeyByValue(userNotifier.keyCurrentUser,e)));
                        }).toList(),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    )),
              )
            ],
          );
        },
      ),
      floatingActionButton: Visibility(
        visible: _show,
        child: Column(
          children: [
            Spacer(),
            userNotifier.currentUser.isNotEmpty
                ? FloatingActionButton.extended(
                    heroTag: "sumary",
                    onPressed: () async {
                      List<String> date1 = [];
                      userNotifier.currentUser.forEach((element) {
                        date1.add(element.date);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowPurchaseReport(
                                  dateUser: date1.toSet().toList(),
                                )
                            //ShowPurchaseReport(dateUser: date1.toSet().toList())
                            ),
                      );
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Icon(Icons.feed),
                    ),
                    label: const Text(
                      'สรุปผล',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Color(0xFF6390E9),
                  )
                : SizedBox(),
            SizedBox(
              height: 7,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: FloatingActionButton.extended(
                heroTag: "add",
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
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
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
      AuthClass().signOut();
  }
}
