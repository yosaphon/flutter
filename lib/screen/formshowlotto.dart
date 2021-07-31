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
  @override
  _FormshowlottoState createState() => _FormshowlottoState();
}

class _FormshowlottoState extends State<Formshowlotto> {
  final formKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _controller = Completer();
  // File file;
  // final ImagePicker _picker = ImagePicker();
  GoogleMapController mapController;
  Position userlocation;
  var convertedImage;
  String urlpiture;
  Userlottery userlottery = Userlottery();
  final user = FirebaseAuth.instance.currentUser;
  // เตรียม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _userltottery =
      FirebaseFirestore.instance.collection("userlottery");

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
                                onSaved: (String number) {
                                  userlottery.number = number;
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
                          onSaved: (String date) {
                            userlottery.date = date;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'จำนวน'),
                          style: TextStyle(fontSize: 25),
                          validator: MultiValidator([
                            RequiredValidator(errorText: "กรุณาป้อน จำนวน")
                          ]),
                          onSaved: (String amount) {
                            userlottery.amount = amount;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'ราคา'),
                          style: TextStyle(fontSize: 25),
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
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
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
                        FutureBuilder(
                          future: _getuserlocation(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                height: 200,
                                width: double.infinity,
                                margin: EdgeInsets.only(left: 30, right: 30),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    GoogleMap(
                                      mapType: MapType.normal,
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(userlocation.latitude,
                                            userlocation.longitude),
                                        zoom: 15,
                                      ),
                                      onMapCreated: _onMapCreated,
                                      myLocationEnabled: true,
                                      compassEnabled: true,
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return _buildGoogleMap(context);
                            }
                          },
                        ),
                        // _buildGoogleMap(context),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
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
                                  "userid": user.uid
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

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
        height: 200,
        width: double.infinity,
        margin: EdgeInsets.only(left: 30, right: 30),
        decoration: BoxDecoration(
          border: Border.all(
            style: BorderStyle.solid,
          ),
        ),
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(13.7535, 100.5237),
                zoom: 15,
              ),
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              compassEnabled: true,
            ),
            // Positioned(
            //   bottom: 50,
            //   right: 10,
            //   child: IconButton(
            //     icon: Icon(Icons.pin_drop),
            //     color: Colors.blue,
            //     onPressed: () {
            //       _addmarker();
            //     },
            //   ),
            // )
          ],
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    // setState(() {
    mapController = controller;
    // });
  }

  Future<Position> _getuserlocation() async {
    try {
      userlocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      userlocation = null;
    }
    return userlocation;
  }

  _addmarker() {
    var marker = Marker(
        markerId: const MarkerId('location'),
        infoWindow: const InfoWindow(title: 'location'));
  }
}
