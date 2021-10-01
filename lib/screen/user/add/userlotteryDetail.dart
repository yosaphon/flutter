import 'dart:async';
import 'package:data_table_2/data_table_2.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/screen/user/add/formUpdatelotto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:lotto/model/userlottery.dart';
import 'package:lotto/screen/user/userlotto/display_userlotto.dart';
import 'package:lotto/screen/user/add/googlemapshow.dart';
import 'package:lotto/widgets/paddingStyle.dart';
import 'package:provider/provider.dart';

class Formshowdetaillotto extends StatefulWidget {
  final docID, userID;
  //final UserNotifier userNotifier;
  Formshowdetaillotto({this.docID, this.userID});
  @override
  _FormshowdetaillottoState createState() =>
      _FormshowdetaillottoState(docID, userID);
}

class _FormshowdetaillottoState extends State<Formshowdetaillotto> {
  final docID, userID;

  _FormshowdetaillottoState(this.docID, this.userID);
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final formKey = GlobalKey<FormState>();

  Completer<GoogleMapController> _controller = Completer();
  var convertedImage;
  String urlpiture;
  UserData userlottery = UserData();
  //final user = FirebaseAuth.instance.currentUser;
  // List<DocumentSnapshot> documents;
  // // เตรียม firebase

  // final Future<FirebaseApp> firebase = Firebase.initializeApp();

  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    print("docID ที่เลือกมา $docID");
    userNotifier.keyCurrentUser.keys.forEach((a) {
      print("{$a}");
    });
    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Color(0xFFF3FFFE),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "รายละเอียด",
            style: TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          // backgroundColor: Colors.transparent,
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Center(
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: 'งวดวันที่ ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: "Mitr")),
                          TextSpan(
                              text: numToWord(
                                  userNotifier.keyCurrentUser[docID].date),
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.orange,
                                  fontFamily: "Mitr")),
                        ]),
                      ),
                    ),
                  ),
                  frameWidget(
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textSty("หมายเลข", Colors.black54),
                              textSty("จำนวนสลาก", Colors.black54),
                              textSty("ราคา", Colors.black54),
                              textSty("สถานะ", Colors.black54)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              textSty(userNotifier.keyCurrentUser[docID].number,
                                  Colors.black),
                              textSty(userNotifier.keyCurrentUser[docID].amount,
                                  Colors.black),
                              textSty(
                                  userNotifier
                                      .keyCurrentUser[docID].lotteryprice,
                                  Colors.black),
                              userNotifier.keyCurrentUser[docID].state == null
                                  ? textSty("รอตรวจ", Colors.black)
                                  : userNotifier.keyCurrentUser[docID].state ==
                                          true
                                      ? textSty("ถูกรางวัล", Colors.black)
                                      : textSty("ไม่ถูกรางวัล", Colors.black)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              textSty("", Colors.black54),
                              textSty("ใบ", Colors.black54),
                              textSty("บาท", Colors.black54),
                              textSty("", Colors.black54),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  userNotifier.keyCurrentUser[docID].state == true
                      ? showReward(userNotifier.keyCurrentUser[docID])
                      : SizedBox(),
                  userNotifier.keyCurrentUser[docID].imageurl != null
                      ? frameWidget(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 20, top: 20),
                                child: textSty("รูปภาพ", Colors.black54),
                              ),
                              Center(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Image.network(
                                        userNotifier
                                            .keyCurrentUser[docID].imageurl,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 10,
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  userNotifier.keyCurrentUser[docID].latlng != null
                      ? frameWidget(
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: textSty("ตำแหน่ง", Colors.black54),
                                ),
                                Center(
                                  child: Container(
                                    child: SizedBox(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: GoogleMap(
                                          mapType: MapType.normal,
                                          markers: userNotifier
                                                      .keyCurrentUser[docID]
                                                      .latlng !=
                                                  null
                                              ? Set.from([
                                                  Marker(
                                                      markerId: MarkerId(
                                                          'google_plex'),
                                                      position: LatLng(
                                                          double.parse(
                                                              userNotifier.keyCurrentUser[docID].latlng
                                                                  .substring(
                                                                      1, 18)),
                                                          double.parse(userNotifier
                                                              .keyCurrentUser[
                                                                  docID]
                                                              .latlng
                                                              .substring(
                                                                  20,
                                                                  userNotifier
                                                                          .keyCurrentUser[docID]
                                                                          .latlng
                                                                          .length -
                                                                      1))))
                                                ])
                                              : null,
                                          onMapCreated: _onMapCreated,
                                          myLocationEnabled: true,
                                          initialCameraPosition: CameraPosition(
                                              target: userNotifier.keyCurrentUser[docID].latlng !=
                                                      null
                                                  ? LatLng(
                                                      double.parse(userNotifier
                                                          .keyCurrentUser[docID]
                                                          .latlng
                                                          .substring(1, 18)),
                                                      double.parse(userNotifier
                                                          .keyCurrentUser[docID]
                                                          .latlng
                                                          .substring(
                                                              20,
                                                              userNotifier
                                                                      .keyCurrentUser[docID]
                                                                      .latlng
                                                                      .length -
                                                                  1)))
                                                  : LatLng(13.736717, 100.523186),
                                              zoom: 15),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 20,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      FloatingActionButton.extended(
                        heroTag: "delete",
                        onPressed: () async {
                          await confirmDialog(
                              context,
                              docID,
                              userNotifier.keyCurrentUser[docID].imageurl,
                              userID);
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.delete),
                        label: const Text(
                          'ลบ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                      Spacer(),
                      userNotifier.keyCurrentUser[docID].state == null
                          ? FloatingActionButton.extended(
                              heroTag: "add",
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FormUpdatelotto(
                                              docID: docID,
                                              amount: int.parse(userNotifier
                                                  .keyCurrentUser[docID]
                                                  .amount),
                                            )));
                                // Navigator.pop(context);
                              },
                              icon: Icon(Icons.edit),
                              label: const Text(
                                'แก้ไข',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.amber,
                            )
                          : Spacer(),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget showReward(UserData userData) {
    return frameWidget(
      DataTable2(
        columns: const <DataColumn>[
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              'หมายเลข',
              style: TextStyle(fontSize: 14),
            ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text('ชื่อรางวัล', style: TextStyle(fontSize: 14)),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text('เงินรางวัล', style: TextStyle(fontSize: 14)),
          ),
        ],
        rows: <DataRow>[
          ...userData.won.map((data) {
            return DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(data.wonNum, style: TextStyle(fontSize: 12)),
                ),
                DataCell(
                  Text(data.name, style: TextStyle(fontSize: 12)),
                ),
                DataCell(Text(data.reward.toString(),
                    style: TextStyle(fontSize: 12))),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget textSty(String text, Color colorfont) {
    return Text(
      text,
      style: TextStyle(fontSize: 18, color: colorfont),
    );
  }

  void _navigateAndDisplaySelection(
      BuildContext context, String locamark) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ShowuserGooglemap(locamark: locamark)),
    );
    userlottery.latlng = result;
  }
}
