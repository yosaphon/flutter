import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lotto/api/prize_api.dart';

import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/model/prizeBox.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/screen/check/showCheckImage.dart';
import 'package:lotto/widgets/paddingStyle.dart';
import 'package:provider/provider.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  ScrollController _scrollController =
      new ScrollController(); // set controller on scrolling
  bool _show = true;

  @override
  void initState() {
    super.initState();
    handleScroll();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }

  //สร้าง List ไว้เก็บ Lottery
  var snapshot;
  List<DocumentSnapshot> documents;
  Map<String, String> date = {};

  Future<void> _refreshProducts(
      BuildContext context, PrizeNotifier prizeNotifier) async {
    await getPrize(prizeNotifier);

    await Future.delayed(Duration(milliseconds: 1000));
    prizeNotifier.selectedPrize = prizeNotifier.prizeList.values.first;
  }
  @override
  Widget build(BuildContext context) {
    PrizeNotifier prizeNotifier = Provider.of<PrizeNotifier>(context);
    if (prizeNotifier.prizeList.isEmpty) {
      return Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: Color(0xFFF3FFFE),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "ผลรางวัลฉลากกินแบ่งรัฐบาล",
              style: TextStyle(color: Colors.black87),
            ),
            shape: RoundedRectangleBorder(),
            // backgroundColor: Colors.transparent,
            backgroundColor: Colors.indigo,
            elevation: 0,
          ),
          body: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Color(0xFFF3FFFE),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "ผลรางวัลฉลากกินแบ่งรัฐบาล",
            style: TextStyle(color: Colors.black87),
          ),
          shape: RoundedRectangleBorder(),
          // backgroundColor: Colors.transparent,
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
        body: Center(
            child: RefreshIndicator(
          onRefresh: () => _refreshProducts(context, prizeNotifier),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownDate(prizeData: prizeNotifier.prizeList.values),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: <Widget>[
                    frameWidget(
                      PrizeBox(
                          //รางวัลที่ 1
                          "รางวัลที่ 1",
                          prizeNotifier.selectedPrize.data['first'].price,
                          prizeNotifier.selectedPrize.data['first'].number,
                          35,
                          2.2,
                          1),
                    ),
                    frameWidget(
                      Row(
                        //รางวัลเลขหน้า 3, เลขท้าย 3
                        children: <Widget>[
                          Expanded(
                            child: PrizeBox(
                                "เลขหน้า 3 ตัว",
                                prizeNotifier
                                    .selectedPrize.data['last3f'].price,
                                prizeNotifier
                                    .selectedPrize.data['last3f'].number,
                                22,
                                4,
                                2),
                          ),
                          Expanded(
                            child: PrizeBox(
                                "เลขท้าย 3 ตัว",
                                prizeNotifier
                                    .selectedPrize.data['last3b'].price,
                                prizeNotifier
                                    .selectedPrize.data['last3b'].number,
                                22,
                                4,
                                2),
                          ),
                        ],
                      ),
                    ),
                    frameWidget(
                      PrizeBox(
                          "เลขท้าย 2 ตัว",
                          prizeNotifier.selectedPrize.data['last2'].price,
                          prizeNotifier.selectedPrize.data['last2'].number,
                          30,
                          2,
                          1),
                    ),
                    frameWidget(
                      PrizeBox(
                          "รางวัลใกล้เคียง",
                          prizeNotifier.selectedPrize.data['near1'].price,
                          prizeNotifier.selectedPrize.data['near1'].number,
                          24,
                          3,
                          2),
                    ),
                    frameWidget(
                      PrizeBox(
                          "รางวัลที่ 2",
                          prizeNotifier.selectedPrize.data['second'].price,
                          prizeNotifier.selectedPrize.data['second'].number,
                          18,
                          3,
                          3),
                    ),
                    frameWidget(
                      PrizeBox(
                          "รางวัลที่ 3",
                          prizeNotifier.selectedPrize.data['third'].price,
                          prizeNotifier.selectedPrize.data['third'].number,
                          16,
                          4,
                          4),
                    ),
                    frameWidget(
                      PrizeBox(
                          "รางวัลที่ 4",
                          prizeNotifier.selectedPrize.data['fourth'].price,
                          prizeNotifier.selectedPrize.data['fourth'].number,
                          16,
                          4,
                          4),
                    ),
                    frameWidget(
                      PrizeBox(
                          "รางวัลที่ 5",
                          prizeNotifier.selectedPrize.data['fifth'].price,
                          prizeNotifier.selectedPrize.data['fifth'].number,
                          16,
                          4,
                          4),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
        floatingActionButton: Visibility(
          visible: _show,
          child: Column(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 45),
                child: FloatingActionButton.extended(
                  heroTag: "showCheckPDF",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new ShowCheckImage(
                                date: prizeNotifier.selectedPrize.date,
                              )),
                    );
                  },
                  icon: Icon(Icons.receipt_long),
                  label: const Text(
                    'ใบตรวจ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.amber,
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    }
  }
}
