import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotto/api/prize_api.dart';
import 'package:lotto/helpers/dialog_helper.dart';
import 'package:lotto/model/PrizeData.dart';
import 'package:lotto/model/checkNumber.dart';
import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/screen/qr_scan_page.dart';
import 'package:provider/provider.dart';

class Formqrcodescan extends StatefulWidget {
  @override
  _FormqrcodescanState createState() => _FormqrcodescanState();
}

String scanresult;
bool checkLineURL = false;
bool checkFacebookURL = false;
bool checkYoutubeURL = false;
List<String> numbers;

class _FormqrcodescanState extends State<Formqrcodescan> {
  final _formKey = GlobalKey<FormState>();
  static List<String> lotterylist = [null];
  List<DocumentSnapshot> documents;
  Map<String, String> date = {};
  List<PrizeData> prizeData = [];
  String dateValue;

  Future loadData(PrizeNotifier prizeNotifier) async {
    if (prizeNotifier.prizeList.isNotEmpty) {
      prizeNotifier.prizeList.forEach((key, value) {
        date[key] = value.date; //เก็บชื่อวัน และ เลขวันเป็น map
        prizeData.add(value);
      });
    dateValue = date.values.first;
    }
    
//เรียกค่าอันสุดท้าย});
  }

  getKeyByValue() {
    return date.keys
        .firstWhere((k) => date[k] == dateValue, //หา Keys โดยใช้ value
            orElse: () => null);
  }

  String numToWord(String n) {
    List<String> month = [
      "มกราคม",
      "กุมภาพันธ์",
      "มีนาคม",
      "เมษายน",
      "พฤษภาคม",
      "มิถุนายน",
      "กรกฎาคม",
      "สิงหาคม",
      "กันยายน",
      "ตุลาคม",
      "พฤศจิกายน",
      "ธันวาคม"
    ];
    List<String> w = n.split('-');

    return int.parse(w[2]).toString() +
        " " +
        month[int.parse(w[1]) - 1] +
        " " +
        (int.parse(w[0]) + 543).toString();
  }

  @override
  Widget build(BuildContext context) {
    PrizeNotifier prizeNotifier = Provider.of<PrizeNotifier>(context);
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Color(0xFFF3FFFE),
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "ตรวจรางวัล",
            style: TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(),
          // backgroundColor: Colors.transparent,
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: loadData(prizeNotifier),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (prizeNotifier.prizeList.isEmpty || dateValue == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      DropdownDate(prizeNotifier.prizeList.values),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._getLottery(),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QRScanPage()),
                                      );
                                    },
                                    child: Text(
                                      'scan qr code',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                );
              }
            }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              var data = new CheckNumber(
                  date.keys.firstWhere(
                      (k) => date[k] == dateValue, //หา Keys โดยใช้ value
                      orElse: () => null),
                  lotterylist,
                  null);
              data
                  .getSnapshot()
                  .then((e) => DialogHelper.exit(context, data.checked));
            }
          },
          icon: Icon(Icons.pin),
          label: const Text(
            'ตรวจ',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xFFF63C4F),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }

  /// get firends text-fields
  List<Widget> _getLottery() {
    List<Widget> lotteryTextFilds = [];
    for (int i = 0; i < lotterylist.length; i++) {
      lotteryTextFilds.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: LotteryTextFilds(i))),
            SizedBox(
              width: 10,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == lotterylist.length - 1, i),
          ],
        ),
      ));
    }
    return lotteryTextFilds;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          lotterylist.insert(0, null);
        } else
          lotterylist.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class LotteryTextFilds extends StatefulWidget {
  final int index;
  LotteryTextFilds(this.index);
  @override
  _LotteryTextFildsState createState() => _LotteryTextFildsState();
}

class _LotteryTextFildsState extends State<LotteryTextFilds> {
  TextEditingController _lotteryController;

  @override
  void initState() {
    super.initState();
    _lotteryController = TextEditingController();
  }

  @override
  void dispose() {
    _lotteryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _lotteryController.text =
          _FormqrcodescanState.lotterylist[widget.index] ?? '';
    });

    return TextFormField(
      style: TextStyle(fontSize: 20),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(6),
      ],
      controller: _lotteryController,
      onChanged: (v) => _FormqrcodescanState.lotterylist[widget.index] = v,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
          border: OutlineInputBorder(),
          hintText: 'กรอกเลขสลากของคุณ'),
      // validator:
      //     MultiValidator([RequiredValidator(errorText: "กรุณาป้อน เลขสลาก")]),
      validator: (v) {
        if (v.isEmpty) {
          return 'กรุณากรอกเลขสลาก';
        } else if (v.trim().length < 6 && v.isNotEmpty)
          return 'กรุณากรอกเลขสลากให้ครบ 6 หลัก';
        return null;
      },
    );
  }
}
