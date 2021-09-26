import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lotto/api/user_api.dart';
import 'package:lotto/model/SumaryData.dart';
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
  List<charts.Series<TotalDataCharts, String>> _seriesData;
  List<String> allresultdate = [];
  List<String> allresultdate2 = [];
  List<String> indexrow = [];
  _ShowPurchaseReportState(this.dateUser);
  //รวมสุทธิ
  double totalProfit = 0, totalReward = 0, totalPay = 0;
  int totalAmount = 0;
  List<double> listotalWon = [], listotalprice = [];
  List<int> listotalAmount = [];

  @override
  void initState() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);

    loadData(userNotifier);
    _seriesData = List<charts.Series<TotalDataCharts, String>>();
    super.initState();
  }

  Future loadData(UserNotifier userNotifier) async {
    await getUser(userNotifier, user.uid,
        start: widget.dateUser[0], end: widget.dateUser[1]);
    totalProfit = 0;
    totalReward = 0;
    totalPay = 0;
    totalAmount = 0;
    userNotifier.currentUser.forEach((element) {
      allresultdate.add(element.date);
    });

    allresultdate2 = allresultdate.toSet().toList();
    sumAllData(userNotifier);
    sumEachData(userNotifier);
    totalProfit += totalReward - totalPay;
    _generateData();
  }

  sumAllData(UserNotifier userNotifier) {
    if (userNotifier.currentUser.isNotEmpty) {
      userNotifier.currentUser.forEach((element) {
        totalReward +=
            element.reward == null ? 0.00 : double.parse(element.reward);
        totalPay += element.lotteryprice == null
            ? 0.00
            : double.parse(element.lotteryprice);
        totalAmount += element.amount == null ? 1 : int.parse(element.amount);
      });
    }
  }

  List<SumaryData> _sumaryData;

  sumEachData(UserNotifier userNotifier) {
    if (userNotifier.currentUser.isNotEmpty) {
      //รวมแต่ละงวด
      double sumReward = 0, sumPay = 0;
      int sumAmount = 0;
      for (var item in dateUser) {
        userNotifier.currentUser.forEach((element) {
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
        if (sumaryData.date.isEmpty) {
          _sumaryData.add(sumaryData);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);

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
          future: loadData(userNotifier),
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
                                  Colors.orange),
                              _buildStatCard(
                                  'Total Lose', '$totalPay', 'บาท', Colors.red),
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
                                  Colors.green),
                              _buildStatCard('Total', '$totalProfit', 'บาท',
                                  Colors.lightBlue),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20.0),
                  sliver: SliverToBoxAdapter(
                      child: Container(
                    height: 350.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${dateUser[0]} TO ${dateUser[1]}",
                            style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.width * 0.7,
                          child: charts.BarChart(
                            _seriesData,
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            animationDuration: Duration(seconds: 5),
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
              ],
            );
          }),
    );
  }

  Expanded _buildStatCard(
      String title, String count, String typestring, MaterialColor color) {
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
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  typestring,
                  style: const TextStyle(
                    color: Colors.white,
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

  _generateData() {
    List<TotalDataCharts> dataWon = [
      // new TotalDataCharts('2021-08-01', 10000),
      // new TotalDataCharts('2021-09-01', 0),
      // new TotalDataCharts('2021-10-01', 2000),
    ];
    List<TotalDataCharts> dataLose = [
      // new TotalDataCharts('2021-08-01', 2500),
      // new TotalDataCharts('2021-09-01', 1200),
      // new TotalDataCharts('2021-10-01', 80),
    ];
    if (_sumaryData != null) {
      _sumaryData.forEach((element) {
        dataWon.add(new TotalDataCharts(element.date, element.sumReward));
        dataLose.add(new TotalDataCharts(element.date, element.sumPay));
      });
    }

    //กุจะอัป
    _seriesData.add(
      charts.Series(
        domainFn: (TotalDataCharts totalDataCharts, _) => totalDataCharts.date,
        measureFn: (TotalDataCharts totalDataCharts, _) =>
            totalDataCharts.total,
        id: 'Win',
        data: dataWon,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (TotalDataCharts totalDataCharts, _) =>
            charts.ColorUtil.fromDartColor(Colors.green),
      ),
    );
    _seriesData.add(
      charts.Series(
        domainFn: (TotalDataCharts totalDataCharts, _) => totalDataCharts.date,
        measureFn: (TotalDataCharts totalDataCharts, _) =>
            totalDataCharts.total,
        id: 'Lose',
        data: dataLose,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (TotalDataCharts totalDataCharts, _) =>
            charts.ColorUtil.fromDartColor(Colors.red),
      ),
    );
  }
}

class TotalDataCharts {
  String date;
  double total;
  TotalDataCharts(this.date, this.total);
}
