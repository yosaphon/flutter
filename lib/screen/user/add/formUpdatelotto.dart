import 'dart:async';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lotto/api/user_api.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/screen/check/qr_scan_page.dart';
import 'package:lotto/widgets/paddingStyle.dart';
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
import 'package:lotto/screen/user/add/googlemapshow.dart';
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
  int amount, price;
  _FormUpdatelottoState(this.docid, this.amount);
  bool imageStateShow = false;
  final formKey = GlobalKey<FormState>();
  bool checkdatestate = false;
  Completer<GoogleMapController> _controller = Completer();
  var convertedImage;
  String urlpiture;
  UserData userlottery = UserData();
  final user = FirebaseAuth.instance.currentUser;
  List<DocumentSnapshot> documents;
  // เตรียม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _userltottery =
      FirebaseFirestore.instance.collection("userlottery");

  File _image;
  final picker = ImagePicker();
  String dateValue, usernumberinput = "";
  ShowuserGooglemap location = ShowuserGooglemap();
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void addAmount() {
    setState(() {
      amount += 1;
      addPrice();
    });
  }

  void removeAmount() {
    setState(() {
      if (amount > 1) {
        amount -= 1;
        addPrice();
      }
    });
  }

  void addPrice() {
    setState(() {
      price = amount * 80;
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

  TextEditingController _numberController;
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
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);
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
              extendBodyBehindAppBar: false,
              backgroundColor: Color(0xFFF3FFFE),
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "แก้ไขข้อมูลสลาก",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
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
                        padding: EdgeInsets.all(20),
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
                                    child: Row(
                                      children: [
                                        RichText(
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: 'งวดวันที่ ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontFamily: "Mitr")),
                                          ]),
                                        ),
                                        dropDownOutDate(prizeNotifier,
                                            snapshot.data['date'])
                                      ],
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    frameWidget(
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              labelText: "เลขสลาก"),
                                          style: TextStyle(fontSize: 20),
                                          key: Key(usernumberinput),
                                          initialValue: usernumberinput ==null? snapshot.data['number']:usernumberinput,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          controller: _numberController,
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
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20.0, right: 30),
                                          child: TextButton(
                                            child: Text(
                                              "QR scan",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.blue[700]),
                                            ),
                                            onPressed: () async {
                                              FocusScope.of(context).unfocus();
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                _getDataAfterScan(context);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                frameWidget(
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "จำนวน",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black54),
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
                                                      height: 25,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color: amount > 1
                                                              ? Colors.pink[200]
                                                              : Colors.black12),
                                                      child: Icon(
                                                        Icons.remove,
                                                        color: amount > 1
                                                            ? Colors.white
                                                            : Colors.black38,
                                                        size: 27,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 35,
                                                    width: 60,
                                                    child: Center(
                                                      child: Text(
                                                        "$amount",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      addAmount();
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color:
                                                              Colors.pink[200]),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 10),
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 27,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: TextFormField(
                                            key: Key(price.toString()),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            decoration: InputDecoration(
                                                labelText: 'ราคา'),
                                            style: TextStyle(fontSize: 20),
                                            initialValue: price == null
                                                ? snapshot.data['lotteryprice']
                                                : price.toString(),
                                            validator: MultiValidator([
                                              RequiredValidator(
                                                  errorText: "กรุณาป้อนราคา")
                                            ]),
                                            onSaved: (String lotteryprice) {
                                              if (lotteryprice == null) {
                                                lotteryprice = "0";
                                              }
                                              userlottery.lotteryprice =
                                                  lotteryprice;
                                            },
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                frameWidget(
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        clipBehavior: Clip.none,
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            textStyle: TextStyle(
                                                fontSize: 30,
                                                color: Colors
                                                    .cyanAccent) // set the background color
                                            ),
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
                                                ? Text("เพิ่มรูป",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black54,
                                                        fontFamily: "Mitr"))
                                                : Text("แก้ไขรูป",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black54,
                                                        fontFamily: "Mitr")),
                                            Spacer(),
                                            Icon(
                                              Icons.image,
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                      ),
                                      if (_image != null) ...[
                                        Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            child: Image.file(_image))
                                      ] else if (snapshot.data['imageurl'] ==
                                          null) ...[
                                        SizedBox(
                                          height: 10,
                                        )
                                      ] else
                                        Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            child: Image.network(
                                                snapshot.data['imageurl'])),
                                      imageStateShow == true
                                          ? Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        getImage(
                                                            ImageSource.camera);
                                                      },
                                                      iconSize: 36,
                                                      color: Colors.amber[400],
                                                      icon: Icon(
                                                          Icons.add_a_photo)),
                                                  IconButton(
                                                      onPressed: () {
                                                        getImage(ImageSource
                                                            .gallery);
                                                      },
                                                      iconSize: 36,
                                                      color: Colors.green[400],
                                                      icon: Icon(
                                                          Icons.collections)),
                                                ],
                                              ),
                                            )
                                          : SizedBox(
                                              height: 10,
                                            ),
                                    ],
                                  ),
                                ),
                                frameWidget(
                                  Column(
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  textStyle: TextStyle(
                                                    fontSize: 30,
                                                  ) // set the background color
                                                  ),
                                              child: Row(
                                                children: [
                                                  snapshot.data["latlng"] ==
                                                          null
                                                      ? Text(
                                                          "เพิ่มตำแหน่ง",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  "Mitr"),
                                                        )
                                                      : Text(
                                                          "แก้ไขตำแหน่ง",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  "Mitr"),
                                                        ),
                                                  Spacer(),
                                                  Icon(
                                                      FontAwesomeIcons
                                                          .mapMarked,
                                                      color: Colors.blueGrey)
                                                ],
                                              ),
                                              onPressed: () async {
                                                _navigateAndDisplaySelection(
                                                    context,
                                                    snapshot.data["latlng"]);
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
                                                        userlottery.latlng !=
                                                                null
                                                            ? Set.from([
                                                                Marker(
                                                                    markerId:
                                                                        MarkerId(
                                                                            'google_plex'),
                                                                    position: LatLng(
                                                                        double.parse(userlottery
                                                                            .latlng
                                                                            .substring(1,
                                                                                18)),
                                                                        double.parse(userlottery
                                                                            .latlng
                                                                            .substring(20,
                                                                                userlottery.latlng.length - 1))))
                                                              ])
                                                            : null,
                                                    onMapCreated: _onMapCreated,
                                                    myLocationEnabled: true,
                                                    initialCameraPosition: CameraPosition(
                                                        target: userlottery.latlng != null
                                                            ? LatLng(
                                                                double.parse(userlottery
                                                                    .latlng
                                                                    .substring(
                                                                        1, 18)),
                                                                double.parse(userlottery
                                                                    .latlng
                                                                    .substring(
                                                                        20,
                                                                        userlottery.latlng.length -
                                                                            1)))
                                                            : LatLng(13.736717,
                                                                100.523186),
                                                        zoom: 15),
                                                  )),
                                            )
                                          ] else if (snapshot.data["latlng"] ==
                                              null) ...[
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
                                                        snapshot.data[
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
                                                    onMapCreated: _onMapCreated,
                                                    myLocationEnabled: true,
                                                    initialCameraPosition: CameraPosition(
                                                        target: snapshot.data[
                                                                    "latlng"] !=
                                                                null
                                                            ? LatLng(
                                                                double.parse(snapshot
                                                                    .data[
                                                                        'latlng']
                                                                    .substring(
                                                                        1, 18)),
                                                                double.parse(snapshot
                                                                    .data['latlng']
                                                                    .substring(20, snapshot.data['latlng'].length - 1)))
                                                            : LatLng(13.736717, 100.523186),
                                                        zoom: 15),
                                                  )),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 20),
                                    child: FloatingActionButton.extended(
                                      heroTag: "add",
                                      onPressed: () async {
                                        if (formKey.currentState.validate()) {
                                          formKey.currentState.save();
                                          if (_image != null) {
                                            deleteImage(
                                                snapshot.data['imageurl']);
                                            await UploadPicture();
                                            await _userltottery
                                                .doc(docid)
                                                .update(
                                                    {"imageurl": urlpiture});
                                          }
                                          if (userlottery.number !=
                                              snapshot.data["number"]) {
                                            await _userltottery
                                                .doc(docid)
                                                .update({
                                              "number": userlottery.number,
                                            });
                                          }
                                          if (checkdatestate = true) {
                                            if (dateValue !=
                                                snapshot.data["date"]) {
                                              await _userltottery
                                                  .doc(docid)
                                                  .update({
                                                "date": dateValue,
                                              });
                                            }
                                          }

                                          if (amount !=
                                              snapshot.data["amount"]) {
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
                                      icon: Icon(Icons.edit),
                                      label: const Text(
                                        'บันทึกการก้ไข',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.amber,
                                    ),
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

  Container dropDownOutDate(
      PrizeNotifier prizeNotifier, String getdatafirebase) {
    return Container(
      alignment: AlignmentDirectional.topCenter,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: dateValue == null ? dateValue = getdatafirebase : dateValue,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.amber,
          ),
          iconSize: 30,
          elevation: 2,
          style: TextStyle(color: Colors.indigo, fontSize: 22),
          underline: Container(
            height: 2,
            color: Colors.red,
          ),
          selectedItemBuilder: (BuildContext context) {
            return prizeNotifier.listOutDate
                .map<DropdownMenuItem<String>>((dynamic value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  numToWord(value),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList();
          },
          onChanged: (String newValue) {
            setState(() {
              checkdatestate = true;
              dateValue = newValue;
              print(newValue);
              print(dateValue);
            });
          },
          items: prizeNotifier.listOutDate
              .map<DropdownMenuItem<String>>((dynamic value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                numToWord(value),
                textAlign: TextAlign.right,
              ),
            );
          }).toList(),
        ),
      ),
    );
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

  void _getDataAfterScan(BuildContext context) async {
    QRCodeData qrCodeData = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QRScanPage(
                wantToCheck: false,
              )),
    );
    setState(() {
      usernumberinput = qrCodeData.number;
      PrizeNotifier prizeNotifier =
          Provider.of<PrizeNotifier>(context, listen: false);

      print("get ${qrCodeData.peroid}");
      int times = qrCodeData.peroid; //งวด
      int index = (times / 2).ceil();
      index = (index - 1);
      dateValue = prizeNotifier.listOutDate[index];
    });
  }
}
