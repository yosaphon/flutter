import 'package:flutter/material.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/screen/user/sumary/purchaseShow.dart';
import 'package:provider/provider.dart';

class PurchaseReportfilter extends StatefulWidget {
  final userdate;
  PurchaseReportfilter({this.userdate});
  @override
  _PurchaseReportfilterState createState() =>
      _PurchaseReportfilterState(userdate);
}

class _PurchaseReportfilterState extends State<PurchaseReportfilter> {
  final userdate;
  _PurchaseReportfilterState(this.userdate);
  int selectedindexsecond = 0;
  bool state = false;
  String start = '', end = '';
  String dateuser, dateValue1, dateValue2;
  List<String> date1 = [], date2 = [];

  @override
  void initState() {
    date1 = userdate;

    date1.sort();
    start = userdate[0];
    end = userdate[date1.length - 1];
    dateValue1 = date1.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "รายงานผลการซื้อสลาก",
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            textcutom("เลือกวันที่ต้องการแสดงรายงาน"),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      changeIndexsecon(0);
                      start = userdate[0];
                      end = userdate[date1.length - 1];
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_outlined,
                        color: selectedindexsecond == 0
                            ? Colors.blue
                            : Colors.white10,
                        size: 20,
                      ),
                      Text(
                        "งวดทั้งหมด",
                        style: TextStyle(
                            color: selectedindexsecond == 0
                                ? Colors.blue
                                : Colors.blueGrey),
                      ),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    side: BorderSide(
                        width: 2,
                        color: selectedindexsecond == 0
                            ? Colors.blue
                            : Colors.blueGrey),
                  ),
                ),
                Spacer(),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      changeIndexsecon(1);
                      start = userdate[date1.length - 1];
                      end = userdate[date1.length - 1];
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_outlined,
                        color: selectedindexsecond == 1
                            ? Colors.blue
                            : Colors.white10,
                        size: 20,
                      ),
                      Text(
                        "งวดล่าสุด",
                        style: TextStyle(
                            color: selectedindexsecond == 1
                                ? Colors.blue
                                : Colors.blueGrey),
                      ),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    side: BorderSide(
                        width: 2,
                        color: selectedindexsecond == 1
                            ? Colors.blue
                            : Colors.blueGrey),
                  ),
                ),
                Spacer(),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      changeIndexsecon(2);
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_outlined,
                        color: selectedindexsecond == 2
                            ? Colors.blue
                            : Colors.white10,
                        size: 20,
                      ),
                      Text(
                        "เลือกงวด",
                        style: TextStyle(
                            color: selectedindexsecond == 2
                                ? Colors.blue
                                : Colors.blueGrey),
                      ),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    side: BorderSide(
                        width: 2,
                        color: selectedindexsecond == 2
                            ? Colors.blue
                            : Colors.blueGrey),
                  ),
                ),
                Spacer(),
              ],
              //:SizedBox(height: 5,),
            ),
            Column(
              children: [
                Row(
                  children: [
                    if (selectedindexsecond == 2) ...[
                      Spacer(),
                      textcutom("เริ่มจาก"),
                      Spacer(),
                      textcutom("ถึง"),
                      Spacer(),
                    ]
                  ],
                ),
                Row(
                  children: [
                    if (selectedindexsecond == 2) ...[
                      Spacer(),
                      Container(
                        alignment: AlignmentDirectional.topCenter,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black26, width: 0.5),
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.only(top: 10.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            menuMaxHeight: 300,
                            value: dateValue1,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.blue,
                            ),
                            iconSize: 30,
                            elevation: 2,
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                            underline: Container(
                              height: 2,
                              color: Colors.blue,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                state = true;
                                date2 = [];
                                start = newValue;
                                dateValue1 = newValue;
                                for (var i = 0; i < date1.length; i++) {
                                  if (i >= date1.indexOf(newValue)) {
                                    date2.add(date1[i]);
                                  }
                                }
                              });
                            },
                            items: date1
                                .map<DropdownMenuItem<String>>((dynamic value) {
                              Widget drop = DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  textAlign: TextAlign.right,
                                ),
                              );

                              return drop;
                            }).toList(),
                          ),
                        ),
                      ),
                      Spacer(),
                      state == false
                          ? IgnorePointer(
                              child: Container(
                                alignment: AlignmentDirectional.topCenter,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Color(0xFFF2F2F2),
                                    border: Border.all(
                                        color: Colors.black26, width: 0.5),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.only(top: 10.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      menuMaxHeight: 300,
                                      value: "0",
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.grey,
                                      ),
                                      iconSize: 30,
                                      elevation: 2,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.grey,
                                      ),
                                      onChanged: (String newValue) {},
                                      items: [
                                        DropdownMenuItem<String>(
                                          value: "0",
                                          child: Text(
                                            "YYYY/MM/DD",
                                            style: TextStyle(fontSize: 11),
                                            textAlign: TextAlign.right,
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            )
                          : Container(
                              alignment: AlignmentDirectional.topCenter,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black26, width: 0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.only(top: 10.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  menuMaxHeight: 300,
                                  value: dateValue2 ?? dateValue1,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.blue,
                                  ),
                                  iconSize: 30,
                                  elevation: 2,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 15),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.blue,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      if (date1.length != userdate.length) {
                                        date1 = userdate;
                                      }
                                      end = newValue;
                                      dateValue2 = newValue;
                                    });
                                  },
                                  items: date2.map<DropdownMenuItem<String>>(
                                      (dynamic value) {
                                    Widget drop = DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        textAlign: TextAlign.right,
                                      ),
                                    );

                                    return drop;
                                    // }
                                    // index2++;
                                  }).toList(),
                                ),
                              ),
                            ),
                      Spacer(),
                    ],
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Spacer(),
                FloatingActionButton.extended(
                  onPressed: () {
                    List<String> dateSelected = [];
                    print("วันทั้งหมด $userdate");
                    print("วันเริ่ม $start :${userdate.indexOf(start)}");
                    print("วันจบ $end  :${userdate.indexOf(end)}");
                    for (var i = 0; i <= userdate.indexOf(end); i++) {
                      if (i>=userdate.indexOf(start)) {
                        dateSelected.add(userdate[i]);
                      }
                    }
                    print("วันเลือกทั้งหมด $dateSelected");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ShowPurchaseReport(dateUser: dateSelected)),
                    );
                  },
                  label: const Text(
                    'ตกลง',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.amberAccent,
                ),
                Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget textcutom(String data) {
    return Text(
      data,
      style: TextStyle(color: Colors.blue, fontSize: 20),
    );
  }

  void changeIndexsecon(int index) {
    setState(() {
      selectedindexsecond = index;
    });
  }
}
