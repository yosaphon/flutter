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
  int totalAmount ;
  List<double> listotalWon = [], listotalprice = [];
  List<int> listotalAmount = [];
  List<SumaryData> _sumaryData = [];
  String dropdownValue = "ทั้งหมด",selectedindex="ทั้งหมด";
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
            element.reward == null ? 0.00 : double.parse(element.reward);
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
                element.reward == null ? 0.00 : double.parse(element.reward);
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
        backgroundColor: Color(0xFFF3FFFE),
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
                  top: 20, left: 20, right: 10, bottom: 20),
              sliver: SliverToBoxAdapter(
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        "สรุป",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                      ),
                      Stack(
                        children: [
                          Text("แสดง"), 
                          dorpdownShow(),
                          if(selectedindex == "ช่วง")...
                          [

                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Text("เริ่ม"),
                           selectdate1(context),
                  
                          Text("ถึง"),
                          state == false
                      ? IgnorePointer(
                          child: selectdateFake(context),
                        )
                      : selectdate2(context),
                              ],
                            ),
                  
                          ]else ...[
                            SizedBox()
                          ]
                          
                        ],
                      )
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
                                Colors.white),
                            _buildStatCard(
                                'เสียเงิน', '฿$totalPay', 'บาท', Colors.white),
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
                                Colors.white),
                            _buildStatCard(
                                'กำไร', '฿$totalProfit', 'บาท', Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 10, right: 10, bottom: 5),
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
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      _builddateCard(
                                          'ถูกรางวัล',
                                          '฿${_sumaryData[index].sumReward}',
                                          'บาท',
                                          Colors.white),
                                      _builddateCard(
                                          'เสียเงิน',
                                          '฿${_sumaryData[index].sumPay}',
                                          'บาท',
                                          Colors.white),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      _builddateCard(
                                          'จำนวน',
                                          '${_sumaryData[index].amount}',
                                          'บาท',
                                          Colors.white),
                                      _builddateCard(
                                          'กำไร',
                                          '฿${_sumaryData[index].sumReward - _sumaryData[index].sumPay}',
                                          'บาท',
                                          Colors.white),
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

  Container selectdateFake(BuildContext context) {
    return Container(
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
                        );
  }

  Container selectdate2(BuildContext context) {
    return Container(
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
                            value: dateValue2 ?? dateValue1,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.blue,
                            ),
                            iconSize: 30,
                            elevation: 2,
                            style:
                                TextStyle(color: Colors.blue, fontSize: 15),
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
                      );
  }

  Container selectdate1(BuildContext context) {
    return Container(
                  alignment: AlignmentDirectional.topCenter,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 0.5),
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
                );
  }

  Widget dorpDownSelectDate(List<String> date,dateUser) {
    Container(
      alignment: AlignmentDirectional.topCenter,
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26, width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.only(top: 10.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          menuMaxHeight: 300,
          value: dateUser,
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
          },
          items: date.map<DropdownMenuItem<String>>((dynamic value) {
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
    );
  }

  Widget dorpdownShow() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            changeIndexsecon(newValue);
          });
        },
        items: <String>['ทั้งหมด', 'ล่าสุด', 'ช่วง']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String count, String typestring, Color color) {
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
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                count,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _builddateCard(
      String title, String count, String typestring, Color color) {
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
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
