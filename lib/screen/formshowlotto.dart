import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lotto/model/userlottery.dart';

class Formshowlotto extends StatefulWidget {
  @override
  _FormshowlottoState createState() => _FormshowlottoState();
}

class _FormshowlottoState extends State<Formshowlotto> {
  final formKey = GlobalKey<FormState>();
  Userlottery userlottery = Userlottery();
  // เตรียม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _userltottery =
      FirebaseFirestore.instance.collection("userlottery");
    
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
                  "บันทึกดสลากผู้ใช้",
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
                        // Text(
                        //   "Email",
                        //   style: TextStyle(fontSize: 20),
                        // ),
                        // TextFormField(
                        //   style: TextStyle(fontSize: 25),
                        //   validator: MultiValidator([
                        //     EmailValidator(errorText: "รูปแบบไม่ถูกต้อง"),
                        //     RequiredValidator(errorText: "กรุณาป้อน Email")
                        //   ]),
                        //   onSaved: (String email) {
                        //     userlottery.email = email;
                        //   },
                        //   keyboardType: TextInputType.emailAddress,
                        // ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        Text(
                          "เลขสลาก",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 25),
                          validator: MultiValidator([
                            RequiredValidator(errorText: "กรุณาป้อน เลขสลาก")
                          ]),
                          onSaved: (String number) {
                            userlottery.number = number;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "จำนวนที่ซื้อ",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 25),
                          validator: MultiValidator([
                            RequiredValidator(errorText: "กรุณาป้อน จำนวน")
                          ]),
                          onSaved: (String amount) {
                            userlottery.amount = amount;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "ราคาที่ซื้อ",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 25),
                          validator: MultiValidator(
                              [RequiredValidator(errorText: "กรุณาป้อนราคา")]),
                          onSaved: (String lotteryprice) {
                            userlottery.lotteryprice = lotteryprice;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "ชื่อผู้ใช้",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 25),
                          validator: RequiredValidator(
                              errorText: "กรุณาป้อนชื่อผู้ใช้"),
                          onSaved: (String username) {
                            userlottery.username = username;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                              "บันทึกข้อมูล",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                await _userltottery.add({
                                  "username": userlottery.username,
                                  "number": userlottery.number,
                                  "amount": userlottery.amount,
                                  "lotteryprice": userlottery.lotteryprice,
                                  // "email": userlottery.email
                                });
                                formKey.currentState.reset();
                              }
                            },
                          ),
                        )
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
