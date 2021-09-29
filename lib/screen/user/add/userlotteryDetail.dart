import 'dart:async';
import 'package:data_table_2/data_table_2.dart';
import 'package:lotto/model/dropdownDate.dart';
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

class Formshowdetaillotto extends StatefulWidget {
  final docid, userID;
  Formshowdetaillotto({this.docid, this.userID});
  @override
  _FormshowdetaillottoState createState() =>
      _FormshowdetaillottoState(docid, userID);
}

class _FormshowdetaillottoState extends State<Formshowdetaillotto> {
  final docid, userID;
  _FormshowdetaillottoState(this.docid, this.userID);
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final formKey = GlobalKey<FormState>();

  Completer<GoogleMapController> _controller = Completer();
  var convertedImage;
  String urlpiture;
  Userlottery userlottery = Userlottery();
  final user = FirebaseAuth.instance.currentUser;
  List<DocumentSnapshot> documents;
  // เตรียม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
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
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                // backgroundColor: Colors.transparent,
                backgroundColor: Colors.indigo,
                elevation: 0,
              ),
              body: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('userlottery')
                      .doc(docid)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData || !snapshot.data.exists) {
                      return CircularProgressIndicator();
                    } else {
                      return Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
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
                                                snapshot.data['date']),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      // crossAxisAlignment: CrossAxisAlignment.,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            textSty("หมายเลข",Colors.black54),
                                            textSty("จำนวนสลาก",Colors.black54),
                                            textSty("ราคา",Colors.black54),
                                            textSty("สถานะ",Colors.black54)
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            textSty(snapshot.data['number'],Colors.black),
                                            textSty(snapshot.data['amount'],Colors.black),
                                            textSty(snapshot.data['lotteryprice'],Colors.black),
                                            snapshot.data["state"] == null
                                                ? textSty("รอตรวจ",Colors.black)
                                                : snapshot.data["state"] == true
                                                    ? textSty("ถูกรางวัล",Colors.black)
                                                    : textSty("ถูกรางวัล",Colors.black)
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                             textSty("",Colors.black54),
                                            textSty("ใบ",Colors.black54),
                                            textSty("บาท",Colors.black54),
                                             textSty("",Colors.black54),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                snapshot.data["state"] == true
                                    ? showReward(snapshot)
                                    : SizedBox(),
                                snapshot.data['imageurl'] != null
                                    ? frameWidget(
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(left: 20,top: 20),
                                              child: textSty(
                                                  "รูปภาพ", Colors.black54),
                                            ),
                                            Center(
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.4,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Image.network(
                                                      snapshot.data['imageurl'],
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
                                snapshot.data["latlng"] != null
                                    ? frameWidget(
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(bottom: 10),
                                                child: textSty(
                                                    "ตำแหน่ง", Colors.black54),
                                              ),
                                              Center(
                                                child: Container(
                                                  child: SizedBox(
                                                      height: 200,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: GoogleMap(
                                                        mapType: MapType.normal,
                                                        markers: snapshot.data[
                                                                    "latlng"] !=
                                                                null
                                                            ? Set.from([
                                                                Marker(
                                                                    markerId:
                                                                        MarkerId(
                                                                            'google_plex'),
                                                                    position: LatLng(
                                                                        double.parse(snapshot
                                                                            .data[
                                                                                "latlng"]
                                                                            .substring(1,
                                                                                18)),
                                                                        double.parse(snapshot.data["latlng"].substring(
                                                                            20,
                                                                            snapshot.data["latlng"].length -
                                                                                1))))
                                                              ])
                                                            : null,
                                                        onMapCreated:
                                                            _onMapCreated,
                                                        myLocationEnabled: true,
                                                        initialCameraPosition: CameraPosition(
                                                            target: snapshot.data["latlng"] !=
                                                                    null
                                                                ? LatLng(
                                                                    double.parse(snapshot.data['latlng']
                                                                        .substring(
                                                                            1,
                                                                            18)),
                                                                    double.parse(snapshot.data['latlng'].substring(
                                                                        20,
                                                                        snapshot.data['latlng'].length -
                                                                            1)))
                                                                : LatLng(
                                                                    13.736717,
                                                                    100.523186),
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
                                        await confirmDialog(context, docid,
                                            snapshot.data["imageurl"], userID);
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
                                    snapshot.data["state"] == null
                                        ? FloatingActionButton.extended(
                                            heroTag: "add",
                                            onPressed: () async {
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FormUpdatelotto(
                                                            docid: docid,
                                                            amount: int.parse(
                                                                snapshot.data[
                                                                    "amount"]),
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
                      );
                    }
                  }),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget showReward(AsyncSnapshot<dynamic> snapshot) {
    return  frameWidget(
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
              ...snapshot.data['won'].map((data) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text(data['wonNum'], style: TextStyle(fontSize: 12)),
                    ),
                    DataCell(
                      Text(data['name'], style: TextStyle(fontSize: 12)),
                    ),
                    DataCell(Text(data['reward'].toString(),
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
