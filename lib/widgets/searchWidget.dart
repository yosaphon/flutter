import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key key,
    this.text,
    this.onChanged,
    this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();
   int selectedindex = 0;
    int selectedindexsecond = 0;

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: 42,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: style.color),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
   void changeIndexfirst(int index) {
      setState(() {
        selectedindex = index;
      });
    }

    void changeIndexsecon(int index) {
      setState(() {
        selectedindexsecond = index;
      });
    }

    Widget textcutom(String data) {
      return Text(
        data,
        style: TextStyle(color: Colors.blue, fontSize: 20),
      );
    }

  Widget _lotteryEditModalBottomSheet(context) {
   
    // void _lotteryEditModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.clear,
                            color: Colors.blue,
                            size: 25,
                          ))
                    ],
                  ),
                  textcutom("สถานะการถูกรางวัล"),
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
                          mystate(() {
                            changeIndexfirst(0);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_outlined,
                              color: selectedindex == 0
                                  ? Colors.blue
                                  : Colors.white10,
                              size: 20,
                            ),
                            Text(
                              "ทั้งหมด",
                              style: TextStyle(
                                  color: selectedindex == 0
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
                              color: selectedindex == 0
                                  ? Colors.blue
                                  : Colors.blueGrey),
                        ),
                      ),
                      Spacer(),
                      // customRadio("ถูกรางวัล", 1),
                      OutlinedButton(
                        onPressed: () {
                          mystate(() {
                            changeIndexfirst(1);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_outlined,
                              color: selectedindex == 1
                                  ? Colors.blue
                                  : Colors.white10,
                              size: 20,
                            ),
                            Text(
                              "ถูกรางวัล",
                              style: TextStyle(
                                  color: selectedindex == 1
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
                              color: selectedindex == 1
                                  ? Colors.blue
                                  : Colors.blueGrey),
                        ),
                      ),
                      Spacer(),
                      // customRadio("ไม่ถูกรางวัล", 2),
                      OutlinedButton(
                        onPressed: () {
                          mystate(() {
                            changeIndexfirst(2);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_outlined,
                              color: selectedindex == 2
                                  ? Colors.blue
                                  : Colors.white10,
                              size: 20,
                            ),
                            Text(
                              "ไม่ถูกรางวัล",
                              style: TextStyle(
                                  color: selectedindex == 2
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
                              color: selectedindex == 2
                                  ? Colors.blue
                                  : Colors.blueGrey),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  textcutom("งวด"),
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
                          mystate(() {
                            changeIndexsecon(0);
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
                              "ทั้งหมด",
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
                      // customRadio("ถูกรางวัล", 1),
                      OutlinedButton(
                        onPressed: () {
                          mystate(() {
                            changeIndexsecon(1);
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
                              "ล่าสุด",
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
                      // customRadio("ไม่ถูกรางวัล", 2),
                      OutlinedButton(
                        onPressed: () {
                          mystate(() {
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      FloatingActionButton.extended(
                        onPressed: () {
                          mystate(() {
                            changeIndexsecon(0);
                            changeIndexfirst(0);
                          });
                        },
                        label: const Text(
                          'ล้าง',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor: Colors.amberAccent,
                      ),
                      Spacer(),
                      FloatingActionButton.extended(
                        onPressed: () {
                          // กดเพื่อส่งค่าออกไป
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
            );
          });
        });

   
  }
}
