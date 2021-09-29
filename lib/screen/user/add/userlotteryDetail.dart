import 'dart:async';
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
  final docid , userID;
  Formshowdetaillotto({this.docid, this.userID});
  @override
  _FormshowdetaillottoState createState() =>
      _FormshowdetaillottoState(docid, userID);
}

class _FormshowdetaillottoState extends State<Formshowdetaillotto> {
  final docid,userID;
  _FormshowdetaillottoState(this.docid,this.userID);
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
                                      top: 20, bottom: 20),
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
                                            text: numToWord(snapshot.data['date']),
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.orange,
                                                fontFamily: "Mitr")),
                                      ]),
                                    ),
                                  ),
                                ),
                                snapshot.data['imageurl'] != null
                                    ? frameWidget(Container(
                                          
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
                                            ),
                                          )),
                                    )
                                    : SizedBox(
                                        height: 10,
                                      ),
                                frameWidget( Container(
                                    height: 40,
                                    
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Spacer(),
                                        Text(
                                          "เลขสลาก",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Spacer(),
                                        Text(
                                          snapshot.data['number'],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                frameWidget(Container(
                                    height: 40,
                                    
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        // Spacer(),
                                        textSty(
                                          "จำนวนสลาก",
                                        ),
                                        Spacer(),
                                        textSty(
                                          snapshot.data['amount'],
                                        ),
                                        Spacer(),
                                        textSty(
                                          "ใบ",
                                        ),
                                        // Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                frameWidget( Container(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Spacer(),
                                        textSty(
                                          "ราคา      ",
                                        ),
                                        Spacer(),
                                        textSty(
                                          snapshot.data['lotteryprice'],
                                        ),
                                        Spacer(),
                                        textSty(
                                          "บาท",
                                        ),
                                        // Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                snapshot.data["state"] != null?frameWidget(
                                  Container(
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
                                        textSty(
                                          "สถานะ    ",
                                        ),
                                        Spacer(),
                                        textSty(
                                          snapshot.data['state'] == true?"ถูกรางวัล":"ไม่ถูกรางวัล",
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ):SizedBox(),
                                 SizedBox(height: 10,),
                                snapshot.data["state"] == true?frameWidget(
                                   Container(
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
                                        textSty(
                                          "เงินรางวัล    ",
                                        ),
                                        Spacer(),
                                        textSty(
                                          snapshot.data['reward'],
                                        ),Spacer(),
                                        textSty(
                                          "บาท",
                                        ),
                                      ],
                                    ),
                                  ),
                                ):SizedBox(),
                                SizedBox(
                                  height: 15,
                                ),
                                snapshot.data["latlng"] != null
                                    ? frameWidget(Container(
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
                                                      docid: docid,amount:int.parse(snapshot.data["amount"]) ,
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
  Widget textSty(String text){
    return Center(
      child: Text(text,style: TextStyle(fontSize: 16),),
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
