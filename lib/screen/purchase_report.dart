import 'package:flutter/material.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/screen/purchaseShow.dart';
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
  String start, end;
  String dateuser, dateValue;
  List<String> date1 = [], date2 = [];

  @override
  void initState() {
    // UserNotifier userNotifier = Provider.of<UserNotifier>(context);

    userdate.forEach((element) {
      date1.add(element.date);
    });
    date2 = date1;
    date1.sort();
    dateValue = date1.first;
    // var ids = [1, 4, 4, 4, 5, 6, 6];
    print(date1);
    date1 = date1.toSet().toList();
    print(date1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "รายงานผลการซื้อสลาก",
          style: TextStyle(color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.black.withOpacity(0.1),
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
                      dateuser = "0";
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
                      start = "0";
                      end = userNotifier.currentUser.length.toString();
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
                            value: dateValue,
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
                                start = newValue;
                                dateValue = newValue;
                                date2.removeRange(0, date1.indexOf(newValue));
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
                            value: dateValue,
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
                                end = newValue;
                                dateValue = newValue;
                              });
                            },
                            items: date2
                                .map<DropdownMenuItem<String>>((dynamic value) {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ShowPurchaseReport(dateuser: dateuser)),
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
