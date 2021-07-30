import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lotto/model/userlottery.dart';
import 'package:lotto/screen/display_userlotto.dart';
import 'package:uuid/uuid.dart';

class Formshowlotto extends StatefulWidget {
  @override
  _FormshowlottoState createState() => _FormshowlottoState();
}

class _FormshowlottoState extends State<Formshowlotto> {
  final formKey = GlobalKey<FormState>();
  // File file;
  // final ImagePicker _picker = ImagePicker();
  var convertedImage;
  String urlpiture;

  String number;
  String amount = "1";
  String lotteryprice = "0";
  String date;

  Userlottery userlottery = Userlottery();
  final user = FirebaseAuth.instance.currentUser;
  // เตรียม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // CollectionReference _userltottery =
  //     FirebaseFirestore.instance.collection("userlottery");

  // Future<void> chooseImage(ImageSource imageSource) async {
  //   try {
  //     // final pickedFile = await _picker.pickImage(
  //     //   source: imageSource,
  //     //   maxWidth: 800,
  //     //   maxHeight: 800,
  //     //   imageQuality: 70,
  //     // );
  //     // setState(() {
  //     //   _imageFile = pickedFile;
  //     // });
  //     final objectimage = await _picker.pickImage(
  //       source: imageSource,
  //       maxHeight: 800,
  //       maxWidth: 800,
  //     );
  //     setState(() {
  //       file = objectimage as File;
  //     });
  //   } catch (e) {}
  // }
  File _image;
  final picker = ImagePicker();

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
    var now = DateTime.now();
    firebase_storage.FirebaseStorage firebaseStorage =
        firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('userimg/$uuid$now');
    firebase_storage.UploadTask uploadTask = reference.putFile(_image);
    urlpiture = await (await uploadTask).ref.getDownloadURL();
    print('url = $urlpiture');
    inserttoFirebase();
  }

  Future inserttoFirebase() async {
    Map<String, dynamic> map = Map();

    map["username"] = user.displayName;
    map["number"] = number;
    map["amount"] = amount;
    map["lotteryprice"] = lotteryprice;
    map["date"] = date;
    map["imageurl"] = urlpiture;
    map["userid"] = user.uid;

    await FirebaseFirestore.instance
        .collection("userlottery")
        .doc()
        .set(map)
        .then((value) {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (value) => UserprofileLottery(),
      );
      Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
    });
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
                              width: 250,
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'เลขสลาก'),
                                style: TextStyle(fontSize: 25),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "กรุณาป้อน เลขสลาก")
                                ]),
                                onChanged: (String string) {
                                  number = string;
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SizedBox(
                                height: 60,
                                width: 100,
                                child: ElevatedButton(
                                  child: Text('Qrcode',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {},
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          //ยังไม่ใช้
                          decoration: InputDecoration(labelText: 'งวดที่'),
                          style: TextStyle(fontSize: 25),
                          onChanged: (String string) {
                            date = string;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'จำนวน'),
                          style: TextStyle(fontSize: 25),
                          initialValue: amount = "1",
                          validator: MultiValidator([
                            RequiredValidator(errorText: "กรุณาป้อน จำนวน")
                          ]),
                          onChanged: (String string) {
                            amount = string;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'ราคา'),
                          initialValue: lotteryprice = "0",
                          style: TextStyle(fontSize: 25),
                          validator: MultiValidator(
                              [RequiredValidator(errorText: "กรุณาป้อนราคา")]),
                          onChanged: (String string) {
                            lotteryprice = string;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: _image == null
                              ? Image.asset('asset/gallery-187-902099.png')
                              : Image.file(_image),
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
                            child: Text(
                              "บันทึกข้อมูล",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              UploadPicture();
                              // if (formKey.currentState.validate()) {

                              //   formKey.currentState.save();
                              //   await _userltottery.add({
                              //     "username": user.displayName,
                              //     "number": userlottery.number,
                              //     "amount": userlottery.amount,
                              //     "lotteryprice": userlottery.lotteryprice,
                              //     "date": userlottery.date,
                              //     "imageurl": userlottery.imageurl,
                              //     "userid": user.uid
                              //   });
                              //   formKey.currentState.reset();
                              // }
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
}
