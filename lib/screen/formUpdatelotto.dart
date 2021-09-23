import 'dart:async';
import 'dart:io';
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
import 'package:uuid/uuid.dart';

class FormUpdatelotto extends StatefulWidget {
  final docid;
  FormUpdatelotto({this.docid});
  @override
  _FormUpdatelottoState createState() => _FormUpdatelottoState(docid);
}

class _FormUpdatelottoState extends State<FormUpdatelotto> {
  final docid;
  _FormUpdatelottoState(this.docid);

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
    print('url = $urlpiture');
  }

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
                  "อัปเดทข้อมูลสลาก",
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
                                  height: 60,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.6,
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
                                        // validator: (v) {
                                        //   if (v.isEmpty) {
                                        //     return 'กรุณากรอกเลขสลาก';
                                        //   } else if (v.trim().length < 6 &&
                                        //       v.isNotEmpty)
                                        //     return 'กรุณากรอกเลขสลากให้ครบ 6 หลัก';
                                        //   return null;
                                        // },
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
                                // TextFormField(
                                //   //ยังไม่ใช้
                                //   decoration: InputDecoration(labelText: 'งวดที่'),
                                //   style: TextStyle(fontSize: 25),
                                //   onSaved: (String date) {
                                //     userlottery.date = date;
                                //   },
                                // ),
                                TextFormField(
                                  inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                  decoration:
                                      InputDecoration(labelText: 'จำนวน'),
                                  style: TextStyle(fontSize: 20),
                                  initialValue: snapshot.data['amount'],
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "กรุณาป้อน จำนวน")
                                  ]),
                                  onSaved: (String amount) {
                                    userlottery.amount = amount;
                                  },
                                  keyboardType: TextInputType.number,
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
                                if (_image != null) ...[
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Image.file(_image))
                                ] else if (snapshot.data['imageurl'] ==
                                    null) ...[
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Image.asset(
                                          'asset/gallery-187-902099.png'))
                                ] else
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Image.network(
                                          snapshot.data['imageurl'])),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceAround,
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
                                ),
                                SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                ))),
                                    child: Text(
                                      "แก้ไขตำแหน่ง",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      _navigateAndDisplaySelection(
                                          context, snapshot.data["latlng"]);
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => ShowuserGooglemap()),
                                      // );
                                      // print(location);
                                    },
                                  ),
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
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                ))),
                                    child: Text(
                                      "บันทึกข้อมูล",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      // await deleteImage(snapshot.data['imageurl']);
                                      // if (_image != null) {
                                      //   await UploadPicture();

                                      // }
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
                                        if (userlottery.amount !=
                                            snapshot.data["amount"]) {
                                          await _userltottery
                                              .doc(docid)
                                              .update({
                                            "amount": userlottery.amount,
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
                                        if (userlottery.date !=
                                            snapshot.data["date"]) {
                                          await _userltottery
                                              .doc(docid)
                                              .update({
                                            "date": userlottery.date,
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
    userlottery.latlng = result;
  }
}
