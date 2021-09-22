import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_automation/flutter_automation.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lotto/model/userlottery.dart';
import 'package:lotto/screen/display_userlotto.dart';
import 'package:lotto/screen/googlemapshow.dart';
import 'package:uuid/uuid.dart';

class Formshowlotto extends StatefulWidget {
  const Formshowlotto({Key key}) : super(key: key);
  @override
  _FormshowlottoState createState() => _FormshowlottoState();
}

class _FormshowlottoState extends State<Formshowlotto> {
  final formKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _controller = Completer();
  var convertedImage;
  String urlpiture;
  Userlottery userlottery = Userlottery();
  final user = FirebaseAuth.instance.currentUser;
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
                  "บันทึกสลากผู้ใช้",
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
              body: Container(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6,
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'เลขสลาก'),
                                style: TextStyle(fontSize: 20),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                validator: MultiValidator([
                                  MinLengthValidator(6,
                                      errorText:
                                          'กรุณากรอกเลขสลากให้ครบ 6 หลัก'),
                                  RequiredValidator(
                                      errorText: "กรุณาป้อน เลขสลาก")
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
                                    borderRadius: BorderRadius.circular(30.0),
                                  ))),
                                  child: Text('Qrcode',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {},
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        // TextFormField(
                        //   //ยังไม่ใช้
                        //   decoration: InputDecoration(labelText: 'งวดที่'),
                        //   style: TextStyle(fontSize: 25),
                        //   onSaved: (String date) {
                        //     userlottery.date = date;
                        //   },
                        // ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'จำนวน'),
                          style: TextStyle(fontSize: 20),
                           inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                          validator: MultiValidator([
                            RequiredValidator(errorText: "กรุณาป้อน จำนวน")
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
                          decoration: InputDecoration(labelText: 'ราคา'),
                          style: TextStyle(fontSize: 20),
                          validator: MultiValidator(
                              [RequiredValidator(errorText: "กรุณาป้อนราคา")]),
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
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: _image != null
                              ? Image.file(_image)
                              : Image.asset('asset/gallery-187-902099.png'),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              "เพิ่มตำแหน่ง",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              _navigateAndDisplaySelection(context);
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
                          height: 20,
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
                              if (_image != null) {
                                await UploadPicture();
                              }

                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                await _userltottery.add({
                                  "username": user.displayName,
                                  "number": userlottery.number,
                                  "amount": userlottery.amount,
                                  "lotteryprice": userlottery.lotteryprice,
                                  "imageurl": urlpiture,
                                  "date": userlottery.date,
                                  "latlng": userlottery.latlng,
                                  "userid": user.uid,
                                  "state" : null,
                                  "reward":null,
                                });

                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                        // Flexible(flex:1,child: Container(color: Colors.amber,))
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowuserGooglemap()),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    // ScaffoldMessenger.of(context)..removeCurrentSnackBar();
    // ..showSnackBar(SnackBar(content: Text('$result')));
    userlottery.latlng = result;
  }
}
