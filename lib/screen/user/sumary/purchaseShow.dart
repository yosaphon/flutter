import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lotto/api/userSumary_api.dart';
import 'package:lotto/model/SumaryData.dart';
import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/notifier/sumary_notifier.dart';
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

  @override
  void initState() {
     UserSumaryNotifier userSumaryNotifier =
        Provider.of<UserSumaryNotifier>(context, listen: false);
    loadData(userSumaryNotifier);
    super.initState();
  }

  Future loadData(UserSumaryNotifier userSumaryNotifier) async {
    //await getUserSumary(userSumaryNotifier, user.uid,
    //   start: widget.dateUser[0], end: widget.dateUser[1]);

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
      body: FutureBuilder<Object>(
        future: null,//loadData(userSumaryNotifier),
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 10, bottom: 20),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    child: Text(
                      "สรุป",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
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
                              _buildStatCard('ถูกรางวัล', '฿$totalReward',
                                  'บาท', Colors.white),
                              _buildStatCard('เสียเงิน', '฿$totalPay', 'บาท',
                                  Colors.white),
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
          );
        },
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
