import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lotto/api/userSumary_api.dart';
import 'package:lotto/api/user_api.dart';
import 'package:lotto/model/SumaryData.dart';
import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/notifier/sumary_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
  int totalAmount = 0;
  List<double> listotalWon = [], listotalprice = [];
  List<int> listotalAmount = [];
  List<SumaryData> _sumaryData;

  @override
  void initState() {
    UserSumaryNotifier userSumaryNotifier =
        Provider.of<UserSumaryNotifier>(context, listen: false);

    loadData(userSumaryNotifier);
    super.initState();
  }

  Future loadData(UserSumaryNotifier userSumaryNotifier) async {
    await getUserSumary(userSumaryNotifier, user.uid,
        start: widget.dateUser[0], end: widget.dateUser[1]);
    totalProfit = 0;
    totalReward = 0;
    totalPay = 0;
    totalAmount = 0;
    userSumaryNotifier.userSumary.forEach((element) {
      allresultdate.add(element.date);
    });
    allresultdate2 = allresultdate.toSet().toList();
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
    if (userSumaryNotifier.userSumary.isNotEmpty) {
      for (var item in dateUser) {
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
        print("จำนวนทั้งหมด= $sumAmount");
        print("ราคารวมทั้งหมด = $sumPay");

        SumaryData sumaryData = SumaryData(
          date: item,
          sumReward: sumReward,
          sumPay: sumPay,
          amount: sumAmount,
        );
          _sumaryData.add(sumaryData);
      }
      print(_sumaryData);
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
          style: TextStyle(color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        backgroundColor: Color(0xFF25D4C2),
        elevation: 0,
      ),
      body: FutureBuilder<Object>(
          future: loadData(userSumaryNotifier),
          builder: (context, snapshot) {
            return CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: <Widget>[
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
                              _buildStatCard('Total Won', '$totalReward', 'บาท',
                                  Colors.white70),
                              _buildStatCard('Total Lose', '$totalPay', 'บาท',
                                  Colors.white70),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Row(
                            children: <Widget>[
                              _buildStatCard(
                                  'Amount',
                                  '${totalAmount.toString()}',
                                  'ใบ',
                                  Colors.white70),
                              _buildStatCard('Total', '$totalProfit', 'บาท',
                                  Colors.white70),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 8, right: 8, bottom: 5),
                  sliver: SliverToBoxAdapter(
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          child: ListView.builder(
                              itemCount: 2,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5.0),
                                                topRight: Radius.circular(5.0),
                                              ),
                                              color: Color(0xfff6f8fa),
                                              border: Border.all(
                                                color: Color(0xffd5d8dc),
                                                width: 1,
                                              )),
                                          child: Row(
                                            children: [
                                              Text(
                                                allresultdate2[0],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )
                                            ],
                                          ),
                                        ),
                                        Table(
                                          border: TableBorder.symmetric(),
                                          columnWidths: const <int,
                                              TableColumnWidth>{
                                            0: FlexColumnWidth(4),
                                            1: FlexColumnWidth(3),
                                            2: FlexColumnWidth(3),
                                            3: FlexColumnWidth(3),
                                          },
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          children: <TableRow>[
                                            TableRow(
                                              children: <Widget>[
                                                TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .top,
                                                  child: Container(
                                                    height: 32,
                                                    width: 32,
                                                    child: Text("Number"),
                                                  ),
                                                ),
                                                TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .top,
                                                  child: Container(
                                                    height: 32,
                                                    width: 32,
                                                    child: Text("Price"),
                                                  ),
                                                ),
                                                TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .top,
                                                  child: Container(
                                                    height: 32,
                                                    width: 32,
                                                    child: Text("Reward"),
                                                  ),
                                                ),
                                                TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .top,
                                                  child: Container(
                                                    height: 32,
                                                    width: 32,
                                                    child: Text("State"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            for (var item in [1, 2, 3, 4])
                                              TableRow(
                                                children: <Widget>[
                                                  TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .top,
                                                    child: Container(
                                                      height: 32,
                                                      width: 32,
                                                      child:
                                                          Text("666666(*10)"),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .top,
                                                    child: Container(
                                                      height: 32,
                                                      width: 32,
                                                      child: Text("10000"),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .top,
                                                    child: Container(
                                                      height: 32,
                                                      width: 32,
                                                      child: Text("ยังไม่ตรวจ"),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .top,
                                                    child: Container(
                                                      height: 32,
                                                      width: 32,
                                                      child: Text("ยังไม่ตรวจ"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }))),
                ),
              ],
            );
          }),
    );
  }

  Expanded _buildStatCard(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  typestring,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
