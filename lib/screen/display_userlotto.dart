import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lotto/model/userlottery.dart';
import 'package:lotto/provider/auth_provider.dart';
import 'package:lotto/screen/formUpdatelotto.dart';
import 'package:lotto/screen/purchase_report.dart';
import 'package:lotto/screen/userlotteryDetail.dart';
import 'package:path/path.dart' as Path;
import '../main.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        backgroundColor: Colors.black.withOpacity(0.1),
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
        stream: number == "" || number == null
            ? FirebaseFirestore.instance
                .collection("userlottery")
                .where('userid', isEqualTo: user.uid)
                .snapshots()
            : FirebaseFirestore.instance
                .collection("userlottery")
                .where('userid', isEqualTo: user.uid)
                .where('number', isEqualTo: number)
                .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
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
                  child: ListView(
                children: snapshot.data.docs.map((document) {
                  return Card(
                    child: ListTile(
                      tileColor: Colors.white54,
                      leading: document['imageurl'] != null
                          ? Image.network(
                              document["imageurl"],
                              width: 100,
                              fit: BoxFit.fitWidth,
                            )
                          : Image.asset(
                              'asset/gallery-187-902099.png',
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
                        icon: document["state"] == true
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : document["state"] == false
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
                        var docid = document.id;
                        var locamark = document["latlng"];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Formshowdetaillotto(
                                  docid: docid)),
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
                            context, document.id, document['imageurl']);

                        // deleteUserLottery(document.id);
                        // FirebaseFirestore.instance.collection('userlottery').doc(document.id).delete();
                        // Navigator.pop(context);
                      },
                    ),
                  );
                }).toList(),
              )),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PurchaseReport()),
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
        ],
      ),
      // FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => Formshowlotto()),
      //     );
      //   },
      //   child: Row(
      //     children: [
      //       Text(
      //         'แก้ไข',
      //         style: TextStyle(
      //           color: Colors.white,
      //         ),
      //       ),
      //       Icon(
      //         Icons.add,
      //         size: 30,
      //       ),
      //     ],
      //   ),
      // ),
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

                  // Row(
                  //   children: [
                  //     Spacer(),
                  //     SizedBox(
                  //       height: 30,
                  //       width: MediaQuery.of(context).size.width * 0.3,
                  //       child: ElevatedButton(
                  //         style: ButtonStyle(
                  //             backgroundColor: MaterialStateProperty.all<Color>(
                  //                 Colors.amberAccent),
                  //             shape: MaterialStateProperty.all<
                  //                     RoundedRectangleBorder>(
                  //                 RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(30.0),
                  //             ))),
                  //         child: Text(
                  //           "ล้าง",
                  //           style: TextStyle(fontSize: 20),
                  //         ),
                  //         onPressed: () async {},
                  //       ),
                  //     ),
                  //     Spacer(),
                  //     SizedBox(
                  //       height: 30,
                  //       width: MediaQuery.of(context).size.width * 0.3,
                  //       child: ElevatedButton(
                  //         style: ButtonStyle(
                  //             backgroundColor: MaterialStateProperty.all<Color>(
                  //                 Colors.amberAccent),
                  //             shape: MaterialStateProperty.all<
                  //                     RoundedRectangleBorder>(
                  //                 RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(30.0),
                  //             ))),
                  //         child: Text(
                  //           "ตกลง",
                  //           style: TextStyle(fontSize: 20),
                  //         ),
                  //         onPressed: () async {},
                  //       ),
                  //     ),
                  //     Spacer(),
                  //   ],
                  // ),
                ],
              ),
            );
          });
        });
  }
}

Future<Null> confirmDialog(
    BuildContext context, String documentId, String imageurl) {
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
                  // String filePath = imageurl
                  // .replaceAll(new
                  // RegExp(r'https://firebasestorage.googleapis.com/v0/b/testfirebase01-6d017.appspot.com/o/userimg%2F'), '').split('?')[0];
                  // firebase_storage.FirebaseStorage.instance.ref().child(filePath).delete().then((_) => print('Successfully deleted $filePath storage item' ));

                  //  firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref().child(imageurl);
                  //   print("url     =   "+imageurl);
                  //   await reference.delete();
                  // print('image deleted'); gs://testfirebase01-6d017.appspot.com/userimg/873e4625-1cca-486e-a649-e4634bbe7cbb
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
