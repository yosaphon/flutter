import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lotto/model/SumaryData.dart';
import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/notifier/sumary_notifier.dart';
import 'package:lotto/screen/user/sumary/purchase_report.dart';
import 'package:provider/provider.dart';

class ShowPurchaseReport extends StatefulWidget {
  final dateUser; // filter สำหรับหาวันที่
  const ShowPurchaseReport({this.dateUser});
  @override
  _ShowPurchaseReportState createState() => _ShowPurchaseReportState(dateUser);
}

class _ShowPurchaseReportState extends State<ShowPurchaseReport> {
  final user = FirebaseAuth.instance.currentUser;
  final dateUser;
  List<String> allresultdate = [];
  List<String> allresultdate2 = [];
  List<String> indexrow = [];
  _ShowPurchaseReportState(this.dateUser);
  //รวมสุทธิ
  double totalProfit = 0, totalReward = 0, totalPay = 0;
  int totalAmount;
  List<double> listotalWon = [], listotalprice = [];
  List<int> listotalAmount = [];
  List<SumaryData> _sumaryData = [];
  String dropdownValue = "ทั้งหมด", selectedindex = "ทั้งหมด";
  bool state = false;
  String start = '', end = '';
  String dateuser, dateValue1, dateValue2;
  List<String> date1 = [], date2 = [];

  @override
  void initState() {
    date1 = dateUser;

    date1.sort();
    start = dateUser[0];
    end = dateUser[date1.length - 1];
    dateValue1 = date1.first;
    UserSumaryNotifier userSumaryNotifier =
        Provider.of<UserSumaryNotifier>(context, listen: false);
    loadData(userSumaryNotifier);
    super.initState();
  }

  Future loadData(UserSumaryNotifier userSumaryNotifier) async {
    totalProfit = 0;
    totalReward = 0;
    totalPay = 0;
    totalAmount = 0;
    for (String item in dateUser) {
      userSumaryNotifier.userSumary.forEach((element) {
        if (item == element.date) {
          allresultdate.add(element.date);
        }
      });
    }

    allresultdate2 = allresultdate.toSet().toList();
    print(allresultdate2);
    await sumAllData(userSumaryNotifier);
    await sumEachData(userSumaryNotifier);
    totalProfit += totalReward - totalPay;
  }

  sumAllData(UserSumaryNotifier userSumaryNotifier) {
    if (userSumaryNotifier.userSumary.isNotEmpty) {
      userSumaryNotifier.userSumary.forEach((element) {
        totalReward +=
            element.won[0].reward == null ? 0.00 : element.won[0].reward;
        totalPay += element.lotteryprice == null
            ? 0.00
            : double.parse(element.lotteryprice);
        totalAmount += element.amount == null ? 1 : int.parse(element.amount);
      });
    }
  }

  sumEachData(UserSumaryNotifier userSumaryNotifier) {
    double sumReward = 0, sumPay = 0;
    int sumAmount = 0;
    _sumaryData = [];
    if (userSumaryNotifier.userSumary.isNotEmpty) {
      for (var item in allresultdate2) {
        sumReward = 0;
        sumPay = 0;
        sumAmount = 0;
        userSumaryNotifier.userSumary.forEach((element) {
          if (item == element.date) {
            sumReward +=
                element.won[0].reward == null ? 0.00 : element.won[0].reward;
            sumPay += element.lotteryprice == null
                ? 0.00
                : double.parse(element.lotteryprice);
            sumAmount += element.amount == null ? 1 : int.parse(element.amount);
          }
        });
        SumaryData sumaryData = SumaryData(
          date: item,
          sumReward: sumReward,
          sumPay: sumPay,
          amount: sumAmount,
        );

        _sumaryData.add(sumaryData);
      }
    }
  }

  void changeIndexsecon(String index) {
    setState(() {
      selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserSumaryNotifier userSumaryNotifier =
        Provider.of<UserSumaryNotifier>(context);

    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "รายงานการซื้อสลาก",
            style: TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 10, bottom: 5),
              sliver: SliverToBoxAdapter(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "สรุปผลการซื้อสลากกินแบ่งรัฐบาล",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                      Stack(
                        children: [
                          Row(
                            children: [
                              Text(
                                "แสดง :",
                                style: TextStyle(color: Colors.black54),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              dorpdownShow(),
                            ],
                          ),
                          if (selectedindex == "เลือกช่วง") ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("เริ่ม :",
                                      style: TextStyle(color: Colors.black54)),
                                  selectdate1(context),
                                  Text("ถึง :",
                                      style: TextStyle(color: Colors.black54)),
                                  state == false
                                      ? IgnorePointer(
                                          child: selectdateFake(context),
                                        )
                                      : selectdate2(context),
                                ],
                              ),
                            ),
                          ] else ...[
                            SizedBox()
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          children: <Widget>[
                            _buildStatCard('ถูกรางวัล', '฿$totalReward', 'บาท',
                                Colors.white, Color(0xFF40E0D0)),
                            _buildStatCard('เสียเงิน', '฿$totalPay', 'บาท',
                                Colors.white, Color(0XFFC70039)),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          children: <Widget>[
                            _buildStatCard(
                                'จำนวนสลาก',
                                '${totalAmount.toString()}',
                                'ใบ',
                                Colors.white,
                                Colors.black),
                            _buildStatCardTotal(
                                'กำไร',
                                '฿$totalProfit',
                                '${totalProfit / 100 * totalPay}',
                                'บาท',
                                Colors.white,
                                totalReward > totalPay
                                    ? Color(0xFF40E0D0)
                                    : totalReward == totalPay
                                        ? Colors.black
                                        : Color(0XFFC70039)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "สรุปผลรายงวด",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                )),
            SliverPadding(
              padding: const EdgeInsets.only(
                  top: 5.0, left: 10, right: 10, bottom: 5),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.53,
                  child: ListView.builder(
                    itemCount: _sumaryData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 4), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Text(
                                      " ${numToWord(_sumaryData[index].date)}",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.2,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text(
                                          'Number',style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Reward',style: TextStyle(fontSize: 14)
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Price',style: TextStyle(fontSize: 14)
                                        ),
                                      ),
                                    ],
                                    rows: const <DataRow>[ 
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text('070456(*1)',style: TextStyle(fontSize: 10))),
                                          DataCell(Text('รางวัลที่1',style: TextStyle(fontSize: 10))),
                                          DataCell(Text('80',style: TextStyle(fontSize: 10))),
                                        ],
                                      ),
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text('485215(*2)',style: TextStyle(fontSize: 10))),
                                          DataCell(Text('เลขท้ายสองตัว',style: TextStyle(fontSize: 10))),
                                          DataCell(Text('240',style: TextStyle(fontSize: 10))),
                                        ],
                                      ),
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text('756885(*2)',style: TextStyle(fontSize: 10))),
                                          DataCell(Text('รางวัลใกล้เคียง',style: TextStyle(fontSize: 10))),
                                          DataCell(Text('300',style: TextStyle(fontSize: 10))),
                                        ],
                                      ),
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text('756885(*2)',style: TextStyle(fontSize: 10))),
                                          DataCell(Text('รางวัลใกล้เคียง',style: TextStyle(fontSize: 10))),
                                          DataCell(Text('300',style: TextStyle(fontSize: 10))),
                                        ],
                                      ),
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text('756885(*2)',style: TextStyle(fontSize: 10))),
                                          DataCell(Text('รางวัลใกล้เคียง',style: TextStyle(fontSize: 10))),
                                          DataCell(Text('300',style: TextStyle(fontSize: 10))),
                                        ],
                                      ),
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text('756885(*2)',style: TextStyle(fontSize: 10))),
                                          DataCell(Text('รางวัลใกล้เคียง',style: TextStyle(fontSize: 10))),
                                          DataCell(Text('300',style: TextStyle(fontSize: 10))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      _builddateCard(
                                          'ถูกรางวัล',
                                          '฿${_sumaryData[index].sumReward}',
                                          'บาท',
                                          Colors.white,
                                          Color(0xFF40E0D0)),
                                      _builddateCard(
                                          'เสียเงิน',
                                          '฿${_sumaryData[index].sumPay}',
                                          'บาท',
                                          Colors.white,
                                          Color(0XFFC70039)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      _builddateCard(
                                          'จำนวน',
                                          '${_sumaryData[index].amount}',
                                          'บาท',
                                          Colors.white,
                                          Colors.black),
                                      _builddateCardTotal(
                                          'กำไร',
                                          '฿${_sumaryData[index].sumReward - _sumaryData[index].sumPay}',
                                          '${(((_sumaryData[index].sumReward - _sumaryData[index].sumPay) / 100) * _sumaryData[index].sumPay)}',
                                          'บาท',
                                          Colors.white,
                                          _sumaryData[index].sumReward >
                                                  _sumaryData[index].sumPay
                                              ? Color(0xFF40E0D0)
                                              : _sumaryData[index].sumReward ==
                                                      _sumaryData[index].sumPay
                                                  ? Colors.black
                                                  : Color(0XFFC70039)),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  selectdateFake(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
          menuMaxHeight: 300,
          value: "0",
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          iconSize: 30,
          elevation: 2,
          style: TextStyle(color: Colors.grey, fontSize: 15),
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
    );
  }

  selectdate2(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        menuMaxHeight: 300,
        value: dateValue2 ?? dateValue1,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black54,
        ),
        iconSize: 30,
        elevation: 2,
        style: TextStyle(color: Colors.black, fontSize: 15),
        underline: Container(
          height: 2,
          color: Colors.blue,
        ),
        onChanged: (String newValue) {
          setState(() {
            if (date1.length != dateUser.length) {
              date1 = dateUser;
            }
            end = newValue;
            dateValue2 = newValue;
          });
        },
        items: date2.map<DropdownMenuItem<String>>((dynamic value) {
          Widget drop = DropdownMenuItem<String>(
            value: value,
            child: Text(
              numToWord(value),
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
          );

          return drop;
          // }
          // index2++;
        }).toList(),
      ),
    );
  }

  selectdate1(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        menuMaxHeight: 300,
        value: dateValue1,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black54,
        ),
        iconSize: 30,
        elevation: 2,
        style: TextStyle(color: Colors.black, fontSize: 15),
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
        items: date1.map<DropdownMenuItem<String>>((dynamic value) {
          Widget drop = DropdownMenuItem<String>(
            value: value,
            child: Text(
              numToWord(value),
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
          );

          return drop;
        }).toList(),
      ),
    );
  }

  Widget dorpdownShow() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black54,
        ),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            changeIndexsecon(newValue);
          });
        },
        items: <String>['ทั้งหมด', 'ล่าสุด', 'เลือกช่วง']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, String typestring,
      Color color, Color colorfont) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "($typestring)",
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 10.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 8),
              child: Text(
                count,
                style: TextStyle(
                  color: colorfont,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _builddateCard(String title, String count, String typestring,
      Color color, Color colorfont) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  "($typestring)",
                  style: const TextStyle(color: Colors.black54, fontSize: 8.0),
                ),
              ],
            ),
            Text(
              count,
              style: TextStyle(
                color: colorfont,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCardTotal(String title, String count, String percen,
      String typestring, Color color, Color colorfont) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "($typestring)",
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 10.0),
                  ),
                  colorfont == Color(0XFFC70039)
                      ? Text(
                          double.parse(percen).toStringAsFixed(1) + "➘",
                          style: TextStyle(color: colorfont, fontSize: 10.0),
                        )
                      : colorfont == Color(0xFF40E0D0)
                          ? Text(
                              "+" +
                                  double.parse(percen).toStringAsFixed(1) +
                                  "➚",
                              style:
                                  TextStyle(color: colorfont, fontSize: 10.0),
                            )
                          : Text(
                              percen,
                              style:
                                  TextStyle(color: colorfont, fontSize: 10.0),
                            ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 8),
              child: Text(
                count,
                style: TextStyle(
                  color: colorfont,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _builddateCardTotal(String title, String count, String percen,
      String typestring, Color color, Color colorfont) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  "($typestring)",
                  style: const TextStyle(color: Colors.black54, fontSize: 8.0),
                ),
                colorfont == Color(0XFFC70039)
                    ? Text(
                        double.parse(percen).toStringAsFixed(1) + "➘",
                        style: TextStyle(color: colorfont, fontSize: 10.0),
                      )
                    : colorfont == Color(0xFF40E0D0)
                        ? Text(
                            "+" + double.parse(percen).toStringAsFixed(1) + "➚",
                            style: TextStyle(color: colorfont, fontSize: 10.0),
                          )
                        : Text(
                            percen,
                            style: TextStyle(color: colorfont, fontSize: 10.0),
                          ),
              ],
            ),
            Text(
              count,
              style: TextStyle(
                color: colorfont,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
