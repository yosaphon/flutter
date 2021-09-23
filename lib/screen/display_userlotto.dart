import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lotto/api/user_api.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/provider/auth_provider.dart';
import 'package:lotto/screen/purchase_report.dart';
import 'package:lotto/screen/userlotteryDetail.dart';
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
  String number;
  void initiateSearch(String val) {
    setState(() {
      number = val.toLowerCase().trim();
    });
  }

  @override
  void initState() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    if (user.uid.isNotEmpty) {
      getUser(userNotifier, user.uid);
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);

    var size = MediaQuery.of(context).size;
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
        backgroundColor: Color(0xFF25D4C2),
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
      body: StreamBuilder(
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (userNotifier.currentUser.isEmpty) {
            return Center(
              child: Text("สามารถเพิ่มสลากเข้าสู้ระบบโดยกดปุ่มเพิ่ม"),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.8,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29.5),
                      ),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(6),
                        ],
                        keyboardType: TextInputType.number,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "กรุณาป้อน เลขสลาก"),
                          MinLengthValidator(6,
                              errorText: 'กรุณากรอกเลขสลากให้ครบ 6 หลัก'),
                        ]),
                        controller: _searchController,
                        onSaved: (val) {
                          // number = val;
                          // initiateSearch(val);
                        },
                        decoration: InputDecoration(
                            hintText: "ค้นหาสลาก",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  number = _searchController.text;
                                });
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(12),
                            border: InputBorder.none,
                            fillColor: Colors.transparent),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.005,
                  ),
                  InkWell(
                    onTap: () {
                      _lotteryEditModalBottomSheet(context);
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.filter_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          tileColor: Colors.white54,
                          leading: userNotifier.currentUser[index].imageurl !=
                                  null
                              ? Image.network(
                                  userNotifier.currentUser[index].imageurl,
                                  width: 100,
                                  fit: BoxFit.fitWidth,
                                )
                              : Image.asset(
                                  'asset/gallery-187-902099.png',
                                  width: 100,
                                  fit: BoxFit.fitWidth,
                                ), //ต้องแก้เป็นรูปที่บันทึก ตอนนี้เอามาแสดงไว้ก่อน
                          title: Text(userNotifier.currentUser[index].number),
                          subtitle: Text("จำนวน " +
                              userNotifier.currentUser[index].amount +
                              " ใบ   " +
                              userNotifier.currentUser[index].lotteryprice +
                              " บาท"),
                          trailing: IconButton(
                            icon: userNotifier.currentUser[index].state == true
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : userNotifier.currentUser[index].state == false
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
                            var docid = userNotifier.docID[index];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Formshowdetaillotto(
                                      docid: docid, userID: user.uid)),
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
                            confirmDialog(
                                context,
                                userNotifier.docID[index],
                                userNotifier.currentUser[index].imageurl,
                                user.uid);

                            // deleteUserLottery(document.id);
                            // FirebaseFirestore.instance.collection('userlottery').doc(document.id).delete();
                            // Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Colors.black,
                      );
                    },
                    itemCount: userNotifier.currentUser.length ?? 0),
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
                date1.toSet().toList();
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PurchaseReportfilter(
                          userdate: date1,
                        )),
              );
            },
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

  Widget _lotteryEditModalBottomSheet(context) {
    // void _lotteryEditModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.clear,
                            color: Colors.blue,
                            size: 25,
                          ))
                    ],
                  ),
                  textcutom("สถานะการถูกรางวัล"),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      OutlinedButton(
                        onPressed: () {
                          mystate(() {
                            changeIndexfirst(0);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_outlined,
                              color: selectedindex == 0
                                  ? Colors.blue
                                  : Colors.white10,
                              size: 20,
                            ),
                            Text(
                              "ทั้งหมด",
                              style: TextStyle(
                                  color: selectedindex == 0
                                      ? Colors.blue
                                      : Colors.blueGrey),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          side: BorderSide(
                              width: 2,
                              color: selectedindex == 0
                                  ? Colors.blue
                                  : Colors.blueGrey),
                        ),
                      ),
                      Spacer(),
                      // customRadio("ถูกรางวัล", 1),
                      OutlinedButton(
                        onPressed: () {
                          mystate(() {
                            changeIndexfirst(1);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_outlined,
                              color: selectedindex == 1
                                  ? Colors.blue
                                  : Colors.white10,
                              size: 20,
                            ),
                            Text(
                              "ถูกรางวัล",
                              style: TextStyle(
                                  color: selectedindex == 1
                                      ? Colors.blue
                                      : Colors.blueGrey),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          side: BorderSide(
                              width: 2,
                              color: selectedindex == 1
                                  ? Colors.blue
                                  : Colors.blueGrey),
                        ),
                      ),
                      Spacer(),
                      // customRadio("ไม่ถูกรางวัล", 2),
                      OutlinedButton(
                        onPressed: () {
                          mystate(() {
                            changeIndexfirst(2);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_outlined,
                              color: selectedindex == 2
                                  ? Colors.blue
                                  : Colors.white10,
                              size: 20,
                            ),
                            Text(
                              "ไม่ถูกรางวัล",
                              style: TextStyle(
                                  color: selectedindex == 2
                                      ? Colors.blue
                                      : Colors.blueGrey),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          side: BorderSide(
                              width: 2,
                              color: selectedindex == 2
                                  ? Colors.blue
                                  : Colors.blueGrey),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  textcutom("งวด"),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      OutlinedButton(
                        onPressed: () {
                          mystate(() {
                            changeIndexsecon(0);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_outlined,
                              color: selectedindexsecond == 0
                                  ? Colors.blue
                                  : Colors.white10,
                              size: 20,
                            ),
                            Text(
                              "ทั้งหมด",
                              style: TextStyle(
                                  color: selectedindexsecond == 0
                                      ? Colors.blue
                                      : Colors.blueGrey),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          side: BorderSide(
                              width: 2,
                              color: selectedindexsecond == 0
                                  ? Colors.blue
                                  : Colors.blueGrey),
                        ),
                      ),
                      Spacer(),
                      // customRadio("ถูกรางวัล", 1),
                      OutlinedButton(
                        onPressed: () {
                          mystate(() {
                            changeIndexsecon(1);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_outlined,
                              color: selectedindexsecond == 1
                                  ? Colors.blue
                                  : Colors.white10,
                              size: 20,
                            ),
                            Text(
                              "ล่าสุด",
                              style: TextStyle(
                                  color: selectedindexsecond == 1
                                      ? Colors.blue
                                      : Colors.blueGrey),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          side: BorderSide(
                              width: 2,
                              color: selectedindexsecond == 1
                                  ? Colors.blue
                                  : Colors.blueGrey),
                        ),
                      ),
                      Spacer(),
                      // customRadio("ไม่ถูกรางวัล", 2),
                      OutlinedButton(
                        onPressed: () {
                          mystate(() {
                            changeIndexsecon(2);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_outlined,
                              color: selectedindexsecond == 2
                                  ? Colors.blue
                                  : Colors.white10,
                              size: 20,
                            ),
                            Text(
                              "เลือกงวด",
                              style: TextStyle(
                                  color: selectedindexsecond == 2
                                      ? Colors.blue
                                      : Colors.blueGrey),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          side: BorderSide(
                              width: 2,
                              color: selectedindexsecond == 2
                                  ? Colors.blue
                                  : Colors.blueGrey),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      FloatingActionButton.extended(
                        onPressed: () {
                          mystate(() {
                            changeIndexsecon(0);
                            changeIndexfirst(0);
                          });
                        },
                        label: const Text(
                          'ล้าง',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor: Colors.amberAccent,
                      ),
                      Spacer(),
                      FloatingActionButton.extended(
                        onPressed: () {
                          // กดเพื่อส่งค่าออกไป
                        },
                        label: const Text(
                          'ตกลง',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor: Colors.amberAccent,
                      ),
                      Spacer(),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }
}

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
            new FlatButton(
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
                if (userID != null) {
                  getUser(userNotifier, userID);
                }
              },
            ),
            SizedBox(
              width: 20,
            ),
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
