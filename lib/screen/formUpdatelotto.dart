import 'dart:async';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lotto/api/user_api.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lotto/model/userlottery.dart';
import 'package:lotto/screen/googlemapshow.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FormUpdatelotto extends StatefulWidget {
  final docid;
  int amount;
  FormUpdatelotto({this.docid, this.amount});
  @override
  _FormUpdatelottoState createState() => _FormUpdatelottoState(docid, amount);
}

class _FormUpdatelottoState extends State<FormUpdatelotto> {
  final docid;
  int amount;
  _FormUpdatelottoState(this.docid, this.amount);
  bool imageStateShow = false;
  final formKey = GlobalKey<FormState>();

  Completer<GoogleMapController> _controller = Completer();
  var convertedImage;
  String urlpiture;
  Userlottery userlottery = Userlottery();
  final user = FirebaseAuth.instance.currentUser;
  List<DocumentSnapshot> documents;
  // เตรียม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _userltottery =
      FirebaseFirestore.instance.collection("userlottery");

  File _image;
  final picker = ImagePicker();
  ShowuserGooglemap location = ShowuserGooglemap();
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void addAmount() {
    setState(() {
      amount += 1;
    });
  }

  void removeAmount() {
    setState(() {
      if (amount > 1) {
        amount -= 1;
      }
    });
  }

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(
        source: imageSource, maxHeight: 1024, maxWidth: 1024, imageQuality: 70);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future UploadPicture() async {
    var uuid = Uuid().v4();
    firebase_storage.FirebaseStorage firebaseStorage =
        firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref().child('userimg/$uuid');
    firebase_storage.UploadTask uploadTask = reference.putFile(_image);
    urlpiture = await (await uploadTask).ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
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
                  "อัปเดทข้อมูลสลาก",
                  style: TextStyle(color: Colors.black),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
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
                                  height: 60,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "เลขสลาก"),
                                        style: TextStyle(fontSize: 20),
                                        initialValue: snapshot.data['number'],
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                          LengthLimitingTextInputFormatter(6),
                                        ],
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText: "กรุณาป้อน เลขสลาก"),
                                          MinLengthValidator(6,
                                              errorText:
                                                  'กรุณากรอกเลขสลากให้ครบ 6 หลัก'),
                                        ]),
                                        onSaved: (String number) {
                                          userlottery.number = number;
                                        },
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: SizedBox(
                                        height: 40,
                                        width: 100,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ))),
                                          child: Text('Qrcode',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          onPressed: () {},
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 15),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "จำนวน",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              removeAmount();
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: amount > 1
                                                      ? Colors.blue
                                                      : Colors.grey),
                                              child: Icon(
                                                Icons.remove,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 35,
                                            width: 60,
                                            child: Center(
                                              child: Text(
                                                "$amount",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              addAmount();
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: Colors.blue),
                                              child: Icon(
                                                Icons.add,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  decoration:
                                      InputDecoration(labelText: 'ราคา'),
                                  style: TextStyle(fontSize: 20),
                                  initialValue: snapshot.data['lotteryprice'],
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "กรุณาป้อนราคา")
                                  ]),
                                  onSaved: (String lotteryprice) {
                                    if (lotteryprice == null) {
                                      lotteryprice = "0";
                                    }
                                    userlottery.lotteryprice = lotteryprice;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (imageStateShow == false) {
                                              imageStateShow = true;
                                            } else if (imageStateShow == true) {
                                              imageStateShow = false;
                                            }
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            snapshot.data['imageurl'] == null
                                                ? Text("เพิ่มรูป")
                                                : Text("แก้ไขรูป"),
                                            Spacer(),
                                            Icon(Icons.image)
                                          ],
                                        ))),
                                if (_image != null) ...[
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Image.file(_image))
                                ] else if (snapshot.data['imageurl'] == null) ...[
                                  SizedBox(
                                    height: 10,
                                  )
                                ] else
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Image.network(
                                          snapshot.data['imageurl'])),
                                imageStateShow == true
                                    ? Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  getImage(ImageSource.camera);
                                                },
                                                iconSize: 36,
                                                color: Colors.amber[400],
                                                icon: Icon(Icons.add_a_photo)),
                                            IconButton(
                                                onPressed: () {
                                                  getImage(ImageSource.gallery);
                                                },
                                                iconSize: 36,
                                                color: Colors.green[400],
                                                icon: Icon(Icons.collections)),
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        height: 10,
                                      ),
                                SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    child: Row(
                                      children: [
                                        snapshot.data["latlng"] == null
                                            ? Text(
                                                "เพิ่มตำแหน่ง",
                                                style: TextStyle(fontSize: 20),
                                              )
                                            : Text(
                                                "แก้ไขตำแหน่ง",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                        Spacer(),
                                        Icon(FontAwesomeIcons.mapMarked)
                                      ],
                                    ),
                                    onPressed: () async {
                                      _navigateAndDisplaySelection(
                                          context, snapshot.data["latlng"]);
                                    },
                                  ),
                                ),
                                if (userlottery.latlng != null) ...[
                                  Container(
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
                                                  markers:
                                                      userlottery.latlng != null
                                                          ? Set.from([
                                                              Marker(
                                                                  markerId:
                                                                      MarkerId(
                                                                          'google_plex'),
                                                                  position: LatLng(
                                                                      double.parse(userlottery
                                                                          .latlng
                                                                          .substring(
                                                                              1,
                                                                              18)),
                                                                      double.parse(userlottery
                                                                          .latlng
                                                                          .substring(
                                                                              20,
                                                                              userlottery.latlng.length - 1))))
                                                            ])
                                                          : null,
                                                  onMapCreated: _onMapCreated,
                                                  myLocationEnabled: true,
                                                  initialCameraPosition: CameraPosition(
                                                      target: userlottery
                                                                  .latlng !=
                                                              null
                                                          ? LatLng(
                                                              double.parse(
                                                                  userlottery
                                                                      .latlng
                                                                      .substring(
                                                                          1, 18)),
                                                              double.parse(userlottery
                                                                  .latlng
                                                                  .substring(
                                                                      20,
                                                                      userlottery
                                                                              .latlng
                                                                              .length -
                                                                          1)))
                                                          : LatLng(13.736717, 100.523186),
                                                      zoom: 15),
                                                )),
                                          )
                                ] else if (snapshot.data["latlng"] == null) ...[
                                  SizedBox(
                                    height: 10,
                                  )
                                ] else
                                  Container(
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
                                              markers:
                                                  snapshot.data["latlng"] !=
                                                          null
                                                      ? Set.from([
                                                          Marker(
                                                              markerId: MarkerId(
                                                                  'google_plex'),
                                                              position: LatLng(
                                                                  double.parse(snapshot
                                                                      .data[
                                                                          "latlng"]
                                                                      .substring(
                                                                          1, 18)),
                                                                  double.parse(snapshot
                                                                      .data[
                                                                          "latlng"]
                                                                      .substring(
                                                                          20,
                                                                          snapshot.data["latlng"].length -
                                                                              1))))
                                                        ])
                                                      : null,
                                              onMapCreated: _onMapCreated,
                                              myLocationEnabled: true,
                                              initialCameraPosition: CameraPosition(
                                                  target: snapshot.data["latlng"] !=
                                                          null
                                                      ? LatLng(
                                                          double.parse(snapshot
                                                              .data['latlng']
                                                              .substring(
                                                                  1, 18)),
                                                          double.parse(snapshot
                                                              .data['latlng']
                                                              .substring(
                                                                  20,
                                                                  snapshot.data['latlng']
                                                                          .length -
                                                                      1)))
                                                      : LatLng(13.736717, 100.523186),
                                                  zoom: 15),
                                            )),
                                      ),
                                        
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ))),
                                    child: Text(
                                      "บันทึกข้อมูล",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        if (_image != null) {
                                          deleteImage(
                                              snapshot.data['imageurl']);
                                          await UploadPicture();
                                          await _userltottery
                                              .doc(docid)
                                              .update({"imageurl": urlpiture});
                                        }
                                        if (userlottery.number !=
                                            snapshot.data["number"]) {
                                          await _userltottery
                                              .doc(docid)
                                              .update({
                                            "number": userlottery.number,
                                          });
                                        }
                                        if (amount != snapshot.data["amount"]) {
                                          await _userltottery
                                              .doc(docid)
                                              .update({
                                            "amount": amount.toString(),
                                          });
                                        }
                                        if (userlottery.lotteryprice !=
                                            snapshot.data["lotteryprice"]) {
                                          await _userltottery
                                              .doc(docid)
                                              .update({
                                            "lotteryprice":
                                                userlottery.lotteryprice,
                                          });
                                        }
                                        if (userlottery.latlng !=
                                            snapshot.data["latlng"]) {
                                          await _userltottery
                                              .doc(docid)
                                              .update({
                                            "latlng": userlottery.latlng,
                                          });
                                        }

                                        Navigator.pop(context);
                                        //getUser(userNotifier, user.uid);
                                      }
                                    },
                                  ),
                                ),
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

  Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
        .replaceAll(new RegExp(r'(\?alt).*'), '');

    final firebase_storage.Reference firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
  }

  void _navigateAndDisplaySelection(
      BuildContext context, String locamark) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ShowuserGooglemap(locamark: locamark)),
    );
    setState(() {
      userlottery.latlng = result;
    });
  }
}
