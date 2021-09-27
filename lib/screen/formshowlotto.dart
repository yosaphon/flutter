import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_automation/flutter_automation.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lotto/api/user_api.dart';
import 'package:lotto/model/userlottery.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/screen/googlemapshow.dart';
import 'package:provider/provider.dart';
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
  String userDate;
  int qtyAmount = 1;
  List<DocumentSnapshot> documents;
  ShowuserGooglemap location = ShowuserGooglemap();
  Future loadData(PrizeNotifier prizeNotifier) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('OutDate').get();
    documents = snapshot.docs;
    for (var i = 0; i <= prizeNotifier.prizeList.values.length; i++) {
      userDate = documents[i].get("date");
    }
  }

  void addAmount() {
    setState(() {
      qtyAmount += 1;
    });
  }

  void removeAmount() {
    setState(() {
      if (qtyAmount > 1) {
        qtyAmount -= 1;
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

  Future uploadPicture() async {
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
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);
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
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                backgroundColor: Colors.indigo,
                elevation: 0,
              ),
              body: FutureBuilder(
                  future: loadData(prizeNotifier),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (userDate == null) {
                      return Center(child: CircularProgressIndicator());
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
                                            labelText: 'เลขสลาก'),
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
                                SizedBox(height: 16),
                                Column(
                                  children: [
                                     Container(
                                       alignment: Alignment.topLeft,
                                       child: Text(
                                                  "จำนวน",style: TextStyle(fontSize: 20),
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
                                                  color: qtyAmount >1 ? Colors.blue:Colors.grey),
                                                  child: Icon(Icons.remove , size: 40,),
                                            ),
                                          ),
                                          Container(
                                            height: 35,
                                                width: 60,
                                            child: Center(
                                              
                                              child: Text(
                                                "$qtyAmount",style: TextStyle(fontSize: 20),
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
                                                  child: Icon(Icons.add , size: 40,),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  decoration:
                                      InputDecoration(labelText: 'ราคา'),
                                  style: TextStyle(fontSize: 20),
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
                                  padding: EdgeInsets.all(20),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: _image != null
                                      ? Image.file(_image)
                                      : Image.asset(
                                          'asset/gallery-187-902099.png'),
                                ),
                                Container(
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
                                        await uploadPicture();
                                      }

                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        await _userltottery.add({
                                          "username": user.displayName,
                                          "number": userlottery.number,
                                          "amount": qtyAmount.toString(),
                                          "lotteryprice":
                                              userlottery.lotteryprice,
                                          "imageurl": urlpiture,
                                          "date": userDate,
                                          "latlng": userlottery.latlng,
                                          "userid": user.uid,
                                          "state": null,
                                          "reward": null,
                                          "namewin": null
                                        });
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

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowuserGooglemap()),
    );
    userlottery.latlng = result;
  }
}
