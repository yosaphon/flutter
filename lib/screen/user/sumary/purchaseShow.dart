import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lotto/model/SumaryData.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/notifier/sumary_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';
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
  List<String> allDateNotUse = [], allresultdate = [], selectedDate = [];
  List<String> indexrow = [];
  _ShowPurchaseReportState(this.dateUser);
  //รวมสุทธิ
  double totalProfit = 0, totalReward = 0, totalPay = 0;
  int totalAmount = 0;
  List<double> listotalWon = [], listotalprice = [];
  List<int> listotalAmount = [];
  List<SumaryData> _sumaryData = [];
  String dropdownValue = "ทั้งหมด", selectedindex = "ทั้งหมด";
  bool state = false;
  String start = '', end = '';
  String dateuser, dateValue1, dateValue2;
  List<String> date1 = [], date2 = [];
  List<UserData> dataAfterSelected = [];
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    date1 = dateUser;
    selectedDate = dateUser;
    date1.sort();
    start = dateUser[0];
    end = dateUser[date1.length - 1];
    dateValue1 = date1.first;
    loadData(selectedDate);
    //loadData(userSumaryNotifier);
    super.initState();
  }

  List<DataInTable> getListOfUserData(String date) {
    List<DataInTable> _dataInTable = [];
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    userNotifier.currentUser.forEach((data) {
      if (data.date == date) {
        for (var i = 0; i < data.won.length; i++) {
          String nameReward;
          switch (data.state) {
            case true:
              nameReward = data.won[i].name.toString();
              break;
            case false:
              nameReward = "ไม่ถูกรางวัล";
              break;

            default:
              nameReward = "ยังไม่ตรวจ";
              break;
          }

          DataInTable dataInTable = new DataInTable(
              number: data.number,
              nameReward: nameReward,
              amount: data.amount,
              price: data.lotteryprice);
          _dataInTable.add(dataInTable);
        }
      }
    });
    return _dataInTable;
  }

  showBySelected(String select) {
    print(select);
    switch (select) {
      case "ทั้งหมด":
        setState(() {
          setDataToNull();
          selectedDate = dateUser;
          loadData(selectedDate);
          print("วันที่เลือกมา $selectedDate");
        });
        break;
      case "ล่าสุด":
        setState(() {
          setDataToNull();
          selectedDate.add(dateUser[dateUser.length - 1]);
          loadData(selectedDate);
          print("วันที่เลือกมา $selectedDate");
        });
        break;
      default:
    }
  }

  void setDataToNull() {
    dataAfterSelected = [];
    _sumaryData = [];
    selectedDate = [];
    allDateNotUse = [];
    allresultdate = [];
  }

  loadDataByRange(start, end) {
    setDataToNull();
    if (dropdownValue == "เลือกช่วง") {
      print("เริ่ม $start ถึง $end");
      print("เริ่มที่ ${dateUser.indexOf(start)}");
      print("ถึง ${dateUser.indexOf(end)}");
      for (var i = 0; i <= dateUser.indexOf(end); i++) {
        if (i >= dateUser.indexOf(start)) {
          selectedDate.add(dateUser[i]);
        }
      }
      setState(() {
        //selectedDate.add(dateUser[dateUser.length - 1]);
        loadData(selectedDate);
        print("วันที่เลือกมาในช่วง $selectedDate");
      });
    }
  }

//โหลดข้อมมูล
  Future loadData(List<String> selectedDate) async {
    UserSumaryNotifier userSumaryNotifier =
        Provider.of<UserSumaryNotifier>(context, listen: false);
    totalProfit = 0;
    totalReward = 0;
    totalPay = 0;
    totalAmount = 0;
    for (String item in selectedDate) {
      userSumaryNotifier.userSumary.forEach((element) {
        if (item == element.date) {
          dataAfterSelected.add(element);
        }
      });
    }
    dataAfterSelected.forEach((element) {
      allDateNotUse.add(element.date);
    });

    allresultdate = allDateNotUse.toSet().toList();
    print("alldate1 $allresultdate");
    await sumAllData(dataAfterSelected);
    await sumEachData(dataAfterSelected);
    totalProfit += totalReward - totalPay;
  }

//โหลดข้อมูลทั้งหมด
  sumAllData(List<UserData> dataAfterSelected) {
    if (selectedDate.isNotEmpty) {
      dataAfterSelected.forEach((element) {
        totalReward +=
            element.won[0].reward == null ? 0.00 : element.won[0].reward;
        totalPay += element.lotteryprice == null
            ? 0.00
            : double.parse(element.lotteryprice);
        totalAmount += element.amount == null ? 1 : int.parse(element.amount);
      });
    }
  }

//โหลดข้อมูลตามงวด
  sumEachData(List<UserData> dataAfterSelected) {
    double sumReward = 0, sumPay = 0;
    int sumAmount = 0;
    _sumaryData = [];

    if (dataAfterSelected.isNotEmpty) {
      for (var item in allresultdate) {
        //print("งวดที่เลือกมาทั้งหมด ${dataAfterSelected}");
        sumReward = 0;
        sumPay = 0;
        sumAmount = 0;
        dataAfterSelected.forEach((element) {
          if (item == element.date) {
            sumReward +=
                element.won[0].reward == null ? 0.00 : element.won[0].reward;
            sumPay += element.lotteryprice == null
                ? 0.00
                : double.parse(element.lotteryprice);
            sumAmount += element.amount == null ? 1 : int.parse(element.amount);
          }
        });
        SumaryData sumaryData = new SumaryData(
          date: item,
          sumReward: sumReward,
          sumPay: sumPay,
          amount: sumAmount,
        );

        _sumaryData.add(sumaryData);
      }
      _sumaryData.forEach((element) {
        print("หลังเลือก ${element.date}");
      });
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
                                constraints: BoxConstraints(
                                  maxHeight: 200, //minimum height
                                ),
                                child: userDataTable(
                                    getListOfUserData(_sumaryData[index].date)),
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

  DataTable userDataTable(List<DataInTable> _userData) {
    return DataTable2(
      scrollController: _controller,
      columns: const <DataColumn>[
        DataColumn2(
          size: ColumnSize.M,
          label: Text(
            'เลข',
            style: TextStyle(fontSize: 12),
          ),
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: Text('รางวัล', style: TextStyle(fontSize: 12)),
        ),
        DataColumn2(
          size: ColumnSize.S,
          label: Text('ราคา', style: TextStyle(fontSize: 12)),
        ),
      ],
      rows: <DataRow>[
        ..._userData.map((data) {
          return DataRow(
            cells: <DataCell>[
              DataCell(
                
                Text("${data.number}(x${data.amount})",
                    style: TextStyle(fontSize: 10)),
              ),
              DataCell(
                Text(data.nameReward.toString(),
                    style: TextStyle(fontSize: 10)),
              ),
              DataCell(Text(data.price, style: TextStyle(fontSize: 10))),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget headerDataTable() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 30),
      child: Row(
        children: [
          Text("data1"),
          SizedBox(
            width: 80,
          ),
          Text("data2"),
          SizedBox(
            width: 50,
          ),
          Text("data3"),
        ],
      ),
    );
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
            loadDataByRange(this.start, this.end);
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
            showBySelected(newValue);
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

class DataInTable {
  String number;
  String amount;
  String nameReward;
  String price;
  DataInTable({this.number, this.amount, this.nameReward, this.price});
}
