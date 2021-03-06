import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lotto/model/UserData.dart';
import 'package:lotto/model/checkNumber.dart';

import 'package:lotto/model/dropdownDate.dart';

import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/screen/check/qr_scan_page.dart';
import 'package:lotto/screen/user/add/googlemapshow.dart';
import 'package:lotto/widgets/paddingStyle.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Formshowlotto extends StatefulWidget {
  const Formshowlotto({Key key}) : super(key: key);
  @override
  _FormshowlottoState createState() => _FormshowlottoState();
}

class _FormshowlottoState extends State<Formshowlotto> {
  final formKey = GlobalKey<FormState>();
  var convertedImage;
  String urlpiture;
  UserData userlottery = UserData();
  final user = FirebaseAuth.instance.currentUser;
  // เตรียม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _userltottery =
      FirebaseFirestore.instance.collection("userlottery");
  File _image;
  final picker = ImagePicker();
  bool imageStateShow = false;
  int qtyAmount = 1, price = 80;
  String dateValue, usernumberinput = "";
  List<DocumentSnapshot> documents;
  GoogleMapController mapController;
  ShowuserGooglemap location = ShowuserGooglemap();

  @override
  void initState() {
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);

    dateValue = prizeNotifier.listOutDate.last;
    print(prizeNotifier.listOutDate);
    print(dateValue);
    super.initState();
  }

  String getDateByPeriod(prizeNotifier, peroid) {
    var date = prizeNotifier.prizeList.values.where((element) {
      return element.period.contains(24);
    });
    return date;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void addAmount() {
    setState(() {
      qtyAmount += 1;
      addPrice();
    });
  }

  void removeAmount() {
    setState(() {
      if (qtyAmount > 1) {
        qtyAmount -= 1;
        addPrice();
      }
    });
  }

  void addPrice() {
    setState(() {
      price = qtyAmount * 80;
    });
  }

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(
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

    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref().child('userimg/$uuid');
    firebase_storage.UploadTask uploadTask = reference.putFile(_image);
    urlpiture = await (await uploadTask).ref.getDownloadURL();
    print('url = $urlpiture');
  }

  TextEditingController _numberController;

  @override
  Widget build(BuildContext context) {
    //_numberController.text = "";
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    // _numberController.text =
    //     "999999";

    //userNotifier.qrcodeData.number;
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
              backgroundColor: Color(0xFFF3FFFE),
              extendBodyBehindAppBar: false,
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "บันทึกสลากผู้ใช้",
                  style: TextStyle(color: Colors.white),
                ),
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                backgroundColor: Colors.indigo,
                elevation: 0,
              ),
              body: FutureBuilder(
                  // future: loadData(prizeNotifier),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (dateValue == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container(
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 20),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    dropDownOutDate(prizeNotifier)
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
                                      initialValue:
                                          usernumberinput, //ค่าเริ่มต้น
                                      autofocus: true,
                                      decoration:
                                          InputDecoration(labelText: 'เลขสลาก'),
                                      style: TextStyle(fontSize: 20),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                        LengthLimitingTextInputFormatter(6),
                                      ],
                                      key: Key(usernumberinput),
                                      controller: _numberController,
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
                                              const Duration(milliseconds: 500),
                                              () {
                                            _getDataAfterScan(context);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                          BorderRadius.circular(
                                                              30),
                                                      color: qtyAmount > 1
                                                          ? Colors.pink[200]
                                                          : Colors.black12),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: qtyAmount > 1
                                                          ? Colors.white
                                                          : Colors.black38,
                                                      size: 27,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 35,
                                                width: 60,
                                                child: Center(
                                                  child: Text(
                                                    "$qtyAmount",
                                                    style:
                                                        TextStyle(fontSize: 20),
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
                                                          BorderRadius.circular(
                                                              30),
                                                      color: Colors.pink[200]),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: TextFormField(
                                        cursorWidth: 2,
                                        key: Key(price.toString()),
                                        initialValue: price.toString(),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        decoration:
                                            InputDecoration(labelText: 'ราคา'),
                                        style: TextStyle(fontSize: 20),
                                        validator: MultiValidator([
                                          // RequiredValidator(
                                          //     errorText: "กรุณาป้อนราคา")
                                        ]),
                                        onSaved: (String lotteryprice) {
                                          if (lotteryprice == null ||
                                              lotteryprice.isEmpty) {
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
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              "เพิ่มรูป",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black54,
                                                  fontFamily: "Mitr"),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.image,
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                      )),
                                  imageStateShow == true
                                      ? imageShow(context)
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
                                              userlottery.latlng != null
                                                  ? Text(
                                                      "แก้ไขตำแหน่ง",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black54,
                                                          fontFamily: "Mitr"),
                                                    )
                                                  : Text(
                                                      "เพิ่มตำแหน่ง",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black54,
                                                          fontFamily: "Mitr"),
                                                    ),
                                              Spacer(),
                                              Icon(
                                                FontAwesomeIcons.mapMarked,
                                                color: Colors.blueGrey,
                                              )
                                            ],
                                          ),
                                          onPressed: () async {
                                            _navigateAndDisplaySelection(
                                                context);
                                          },
                                        ),
                                      ),
                                      userlottery.latlng != null
                                          ? googleMapShow(context)
                                          : SizedBox(
                                              height: 10,
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }),
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.amber,
                  heroTag: "add",
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Future.delayed(const Duration(milliseconds: 300), () {
                      
                      setState(() {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();

                          addToFirebase(context, prizeNotifier, userNotifier);
                        }
                      });
                    });
                  },
                  label: Text(
                    "บันทึก",
                    style: TextStyle(fontSize: 18),
                  ),
                  icon: Icon(Icons.save),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Container dropDownOutDate(PrizeNotifier prizeNotifier) {
    return Container(
      alignment: AlignmentDirectional.topCenter,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: dateValue,
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
                  style: TextStyle(color: Colors.black, fontFamily: "Mitr"),
                ),
              );
            }).toList();
          },
          onChanged: (String newValue) {
            setState(() {
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
                style: TextStyle(fontFamily: "Mitr"),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> addToFirebase(BuildContext context, PrizeNotifier prizeNotifier,
      UserNotifier userNotifier) async {
    if (_image != null) {
      await uploadPicture();
    }
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      UserData dataForAdd = UserData.fromJson({
        "username": user.displayName,
        "number": userlottery.number,
        "amount": qtyAmount.toString(),
        "lotteryprice": userlottery.lotteryprice,
        "imageurl": urlpiture,
        "date": dateValue,
        "latlng": userlottery.latlng,
        "userid": user.uid,
        "token": userNotifier.token,
        "won": []
      });
      String nonsplit = dateValue;
      if (prizeNotifier.prizeList.keys.contains(nonsplit.split("-").join())) {
        CheckNumber checkNumber = CheckNumber(
            userNum: [userlottery.number],
            prizeNotifier: prizeNotifier,
            date: dateValue);
        List<CheckResult> _checkResult = checkNumber.getCheckedData();

        for (var i = 0; i < _checkResult.length; i++) {
          dataForAdd.state = _checkResult[i].status;
          dataForAdd.won.add(new Won(
              wonNum: _checkResult[i].number,
              name: _checkResult[i].name,
              reward: double.parse(_checkResult[i].reword)));
          print(_checkResult[i].number);
          print(_checkResult[i].name);
          print(_checkResult[i].reword.toString());
        }
      } else {
        dataForAdd.state = null;
        dataForAdd.won.add(new Won(name: null, wonNum: null, reward: 0));
      }
      await _userltottery.add(jsonDecode(userDataToJson(dataForAdd)));
      bool checkstate = false;
      Navigator.pop(context, checkstate);
    }
  }

  Column imageShow(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: _image != null ? MediaQuery.of(context).size.height * 0.3 : 5,
          child: _image != null ? Image.file(_image) : SizedBox(),
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
                  color: Colors.blueGrey,
                  icon: Icon(Icons.add_a_photo)),
              IconButton(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  iconSize: 36,
                  color: Colors.lightBlue[400],
                  icon: Icon(Icons.collections)),
            ],
          ),
        ),
      ],
    );
  }

  Container googleMapShow(BuildContext context) {
    return Container(
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
      child: SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            mapType: MapType.normal,
            markers: userlottery.latlng != null
                ? Set.from([
                    Marker(
                        markerId: MarkerId('google_plex'),
                        position: LatLng(
                            double.parse(userlottery.latlng.substring(1, 18)),
                            double.parse(userlottery.latlng
                                .substring(20, userlottery.latlng.length - 1))))
                  ])
                : null,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
                target: userlottery.latlng != null
                    ? LatLng(
                        double.parse(userlottery.latlng.substring(1, 18)),
                        double.parse(userlottery.latlng
                            .substring(20, userlottery.latlng.length - 1)))
                    : LatLng(13.736717, 100.523186),
                zoom: 15),
          )),
    );
  }

  Container container1(Widget x) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 7,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
        //border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: x,
    );
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowuserGooglemap()),
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
