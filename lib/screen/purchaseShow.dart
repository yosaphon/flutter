import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lotto/api/user_api.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ShowPurchaseReport extends StatefulWidget {
  final dateuser; // filter สำหรับหาวันที่
  const ShowPurchaseReport({this.dateuser});
  @override
  _ShowPurchaseReportState createState() => _ShowPurchaseReportState(dateuser);
}
class _ShowPurchaseReportState extends State<ShowPurchaseReport> {
  final user = FirebaseAuth.instance.currentUser;
  final dateuser;
  List<charts.Series<TotalDataCharts, String>> _seriesData;
  _generateData() {
    var dataWon = 
    [
      new TotalDataCharts('2021-08-01', 10000),
      new TotalDataCharts('2021-09-01', 0),
      new TotalDataCharts('2021-10-01', 2000),
    ];
    var dataLose = [
      new TotalDataCharts('2021-08-01', 2500),
      new TotalDataCharts('2021-09-01', 1200),
      new TotalDataCharts('2021-10-01', 80),
    ];
    //กุจะอัป
    _seriesData.add(
      charts.Series(
        domainFn: (TotalDataCharts totalDataCharts, _) => totalDataCharts.date,
        measureFn: (TotalDataCharts totalDataCharts, _) => totalDataCharts.total,
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
        measureFn: (TotalDataCharts totalDataCharts, _) => totalDataCharts.total,
        id: 'Lose',
        data: dataLose,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (TotalDataCharts totalDataCharts, _) =>
           charts.ColorUtil.fromDartColor(Colors.red),
      ),
    );
  }
  
  List<String> allresultdate = [];
  List<String> allresultdate2 = [];
  List<String> indexrow = [];
  _ShowPurchaseReportState(this.dateuser);
  double totalProfit = 0,
      totalWon = 0,
      totalLose = 0,
      totalReward = 0,
      totalPay = 0;
  int totalAmount = 0;
  List<double> listotalWon = [], listotalprice = [];
  List<int> listotalAmount = [];
  @override
  void initState() {
    loadData();
    _seriesData = List<charts.Series<TotalDataCharts, String>>();
    _generateData();
    super.initState();
  }

  void loadData() async {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    await getUser(userNotifier, user.uid,
        start: widget.dateuser[0], end: widget.dateuser[1]);
    userNotifier.currentUser.forEach((element) {
      allresultdate.add(element.date);
    });
    userNotifier.currentUser.forEach((element) {
      listotalWon
          .add(element.reward == null ? 0.00 : double.parse(element.reward));

      listotalprice.add(element.lotteryprice == null
          ? 0.00
          : double.parse(element.lotteryprice));

      listotalAmount
          .add(element.amount == null ? 0.00 : int.parse(element.amount));
    });
    for (var i = 0; i < listotalAmount.length; i++) {
      //เงินรางวัลที่ถูก
      if (listotalWon[i] == null) {
        totalWon += 0.00;
      } else if (listotalWon[i] != null) {
        totalWon += listotalWon[i] * double.parse(listotalAmount[i].toString());
      }
      //เงินที่ซื้อ
      if (listotalprice[i] == null) {
        totalLose += 0.00;
      } else if (listotalprice[i] != null) {
        totalLose += listotalprice[i];
      }
      //จำนวนทั้งหมด
      if (listotalAmount[i] == null) {
        totalAmount += 0;
      } else if (listotalAmount[i] != null) {
        totalAmount += listotalAmount[i];
      }
    }
    totalProfit = totalWon - totalLose;
    for (var i = 0; i <= allresultdate.length - 1; i++) {
      indexrow += ["$i"];
    }
    allresultdate2 = allresultdate.toSet().toList();
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
      // body: ListView.builder(
      //     itemCount: allresultdate2.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return Card(
      //         child: Container(
      //           padding: EdgeInsets.all(10),

      //           child: Column(
      //             children: [
      //               Container(
      //                 decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.only(
      //                       topLeft: Radius.circular(5.0),
      //                       topRight: Radius.circular(5.0),
      //                     ),
      //                     color: Color(0xfff6f8fa),
      //                     border: Border.all(
      //                       color: Color(0xffd5d8dc),
      //                       width: 1,
      //                     )),
      //                 child: Row(
      //                   children: [
      //                     Text(
      //                       allresultdate2[index],
      //                       style: TextStyle(fontWeight: FontWeight.w700),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //               Table(
      //                 border: TableBorder.symmetric(),
      //                 columnWidths: const <int, TableColumnWidth>{
      //                   0: FlexColumnWidth(3),
      //                   1: FlexColumnWidth(3),
      //                   2: FlexColumnWidth(3),
      //                   3: FlexColumnWidth(3),
      //                 },
      //                 defaultVerticalAlignment:
      //                     TableCellVerticalAlignment.middle,
      //                 children: <TableRow>[
      //                   TableRow(
      //                     children: <Widget>[
      //                       TableCell(
      //                         verticalAlignment:
      //                             TableCellVerticalAlignment.top,
      //                         child: Container(
      //                           height: 32,
      //                           width: 32,
      //                           child: textSty("Number"),
      //                         ),
      //                       ),
      //                       TableCell(
      //                         verticalAlignment:
      //                             TableCellVerticalAlignment.top,
      //                         child: Container(
      //                           height: 32,
      //                           width: 32,
      //                           child: textSty("Lottery Price"),
      //                         ),
      //                       ),
      //                       TableCell(
      //                         verticalAlignment:
      //                             TableCellVerticalAlignment.top,
      //                         child: Container(
      //                           height: 32,
      //                           width: 32,
      //                           child: textSty("Reward"),
      //                         ),
      //                       ),
      //                       TableCell(
      //                         verticalAlignment:
      //                             TableCellVerticalAlignment.top,
      //                         child: Container(
      //                           height: 32,
      //                           width: 32,
      //                           child: textSty("State"),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   for (var item in indexrow)
      //                     TableRow(

      //                       children: <Widget>[
      //                         TableCell(

      //                           verticalAlignment:
      //                               TableCellVerticalAlignment.top,
      //                           child: Container(
      //                             height: 32,
      //                             width: 32,
      //                             child: textSty("${userNotifier.currentUser[int.parse(item)].number}(x${userNotifier.currentUser[int.parse(item)].amount})"),
      //                           ),
      //                         ),
      //                         TableCell(
      //                           verticalAlignment:
      //                               TableCellVerticalAlignment.top,
      //                           child: Container(
      //                             height: 32,
      //                             width: 32,
      //                             child: textSty("${userNotifier.currentUser[int.parse(item)].lotteryprice}"),
      //                           ),
      //                         ),
      //                         TableCell(
      //                           verticalAlignment:
      //                               TableCellVerticalAlignment.top,
      //                           child: Container(
      //                             height: 32,
      //                             width: 32,
      //                             child: userNotifier.currentUser[int.parse(item)].reward ==null?textSty("ยังไม่ตรวจ"): textSty("${userNotifier.currentUser[int.parse(item)].reward}"),
      //                           ),
      //                         ),
      //                         TableCell(
      //                           verticalAlignment:
      //                               TableCellVerticalAlignment.top,
      //                           child: Container(
      //                             height: 32,
      //                             width: 32,
      //                             child: userNotifier.currentUser[int.parse(item)].namewin ==null?textSty("ยังไม่ตรวจ"): textSty("${userNotifier.currentUser[int.parse(item)].namewin}"),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     })
      body: CustomScrollView(
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
                        _buildStatCard(
                            'Total Won', '$totalWon', 'บาท', Colors.orange),
                        _buildStatCard(
                            'Total Lose', '$totalLose', 'บาท', Colors.red),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        _buildStatCard('Amount', '${totalAmount.toString()}',
                            'ใบ', Colors.green),
                        _buildStatCard(
                            'Total', '$totalProfit', 'บาท', Colors.lightBlue),
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
                      "${dateuser[0]} TO ${dateuser[1]}",
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width *0.7,
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
      ),
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
}

class TotalDataCharts {
  String date;
  int total;
  TotalDataCharts(this.date, this.total);
}
