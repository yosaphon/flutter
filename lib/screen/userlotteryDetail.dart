import 'dart:async';
import 'package:lotto/screen/formUpdatelotto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:image_picker/image_picker.dart';
import 'package:lotto/model/userlottery.dart';
import 'package:lotto/screen/display_userlotto.dart';
import 'package:lotto/screen/googlemapshow.dart';


class Formshowdetaillotto extends StatefulWidget {
  final docid , userID;
  Formshowdetaillotto({this.docid, this.userID});
  @override
  _FormshowdetaillottoState createState() =>
      _FormshowdetaillottoState(docid, userID);
}

class _FormshowdetaillottoState extends State<Formshowdetaillotto> {
  final docid,userID;
  // final locamark;

  _FormshowdetaillottoState(this.docid,this.userID);
  GoogleMapController mapController;
  // final Map<String, Marker> _markers = {};
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // final  = Marker(markerId: markerId)
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

  // Set<Marker> usermark() {
  //   return <Marker>[localMarker()].toSet();
  // }

  // Marker localMarker() {
  //   return Marker(
  //       markerId: MarkerId('userbuy'),
  //       position: LatLng(double.parse(locamark.substring(1, 18)),
  //           double.parse(locamark.substring(20, locamark.length - 1))));
  // }

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
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "รายละเอียด",
                  style: TextStyle(color: Colors.black),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                // backgroundColor: Colors.transparent,
                backgroundColor: Colors.black.withOpacity(0.1),
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
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                snapshot.data['imageurl'] != null
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Colors.teal.shade100,
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 17),
                                                  blurRadius: 23,
                                                  spreadRadius: -13,
                                                  color: Colors.black38)
                                            ]),
                                        margin: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        padding: EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Image.network(
                                            snapshot.data['imageurl'],
                                            fit: BoxFit.cover,
                                            // width: MediaQuery.of(context)
                                            //         .size
                                            //         .width *
                                            //     1,
                                            // height: MediaQuery.of(context)
                                            //         .size
                                            //         .height *
                                            //     1,
                                          ),
                                        ))
                                    : SizedBox(
                                        height: 10,
                                      ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: 40,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.teal.shade100,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 17),
                                            blurRadius: 23,
                                            spreadRadius: -13,
                                            color: Colors.black38)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Spacer(),
                                      Text(
                                        "เลขสลาก",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Spacer(),
                                      Text(
                                        snapshot.data['number'],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: 40,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.teal.shade100,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 17),
                                            blurRadius: 23,
                                            spreadRadius: -13,
                                            color: Colors.black38)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Spacer(),
                                      Text(
                                        "จำนวนสลาก",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Spacer(),
                                      Text(
                                        snapshot.data['amount'],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Spacer(),
                                      Text(
                                        "ใบ",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      // Spacer(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: 40,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.teal.shade100,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 17),
                                            blurRadius: 23,
                                            spreadRadius: -13,
                                            color: Colors.black38)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Spacer(),
                                      Text(
                                        "ราคา    ",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Spacer(),
                                      Text(
                                        snapshot.data['lotteryprice'],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Spacer(),
                                      Text(
                                        "บาท",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      // Spacer(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                snapshot.data["state"] != null?Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: 45,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.teal.shade100,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 17),
                                            blurRadius: 23,
                                            spreadRadius: -13,
                                            color: Colors.black38)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Spacer(),
                                      Text(
                                        "สถานะ    ",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Spacer(),
                                      Text(
                                        snapshot.data['state'] == true?"ถูกรางวัล":"ไม่ถูกรางวัล",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ):SizedBox(),
                                 SizedBox(height: 10,),
                                snapshot.data["state"] == true?Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: 45,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.teal.shade100,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 17),
                                            blurRadius: 23,
                                            spreadRadius: -13,
                                            color: Colors.black38)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Spacer(),
                                      Text(
                                        "เงินรางวัล    ",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Spacer(),
                                      Text(
                                        snapshot.data['reward'],
                                        style: TextStyle(fontSize: 16),
                                      ),Spacer(),
                                      Text(
                                        "บาท",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ):SizedBox(),
                                SizedBox(
                                  height: 15,
                                ),
                                snapshot.data["latlng"] != null
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Colors.teal.shade100,
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 17),
                                                  blurRadius: 23,
                                                  spreadRadius: -13,
                                                  color: Colors.black38)
                                            ]),
                                        child: SizedBox(
                                            height: 200,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: GoogleMap(
                                              mapType: MapType.normal,
                                              markers: snapshot.data["latlng"] !=null? Set.from([
                                                Marker(
                                                    markerId:
                                                        MarkerId('google_plex'),
                                                    position: LatLng(
                                                        double.parse(snapshot
                                                            .data["latlng"]
                                                            .substring(1, 18)),
                                                        double.parse(snapshot
                                                            .data["latlng"]
                                                            .substring(20,snapshot.data["latlng"].length -1))))
                                              ]):null,
                                              onMapCreated: _onMapCreated,
                                              myLocationEnabled: true,
                                              initialCameraPosition: CameraPosition(
                                                  target: snapshot.data["latlng"] != null
                                                      ? LatLng(
                                                          double.parse(snapshot
                                                              .data['latlng']
                                                              .substring(1, 18)),
                                                          double.parse(snapshot
                                                              .data['latlng']
                                                              .substring(20,snapshot.data['latlng'].length-1)))
                                                      : LatLng(13.736717, 100.523186),
                                                  zoom: 15),
                                            )),
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
                                      heroTag: "btn1",
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
                                    
                                    snapshot.data["state"] == null ? FloatingActionButton.extended(
                                      heroTag: "btn2",
                                      onPressed: () async {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FormUpdatelotto(
                                                      docid: docid,
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
                                    ):Spacer(),
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

  void _navigateAndDisplaySelection(
      BuildContext context, String locamark) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ShowuserGooglemap(locamark: locamark)),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text('$result')));
    userlottery.latlng = result;
  }
}
