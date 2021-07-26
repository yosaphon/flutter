import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
class CheckedDialog extends StatelessWidget {
  final Map<int, Map<String, dynamic>> data;
  final BuildContext context;

  Color boxColor;
  List<Widget> dialogList = [];

  CheckedDialog(this.data, this.context) {
    data.forEach((key, value) {
      Widget result = wonOrNot(value, context);
      dialogList.add(Container(
        width: 350,
        decoration: BoxDecoration(
            color: boxColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Stack(children: [
            Column(
              children: [
                result,
              ],
            ),
            Footer(
              backgroundColor: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "ตกลง",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                  SizedBox(
                    width: 60,
                  ),
                  TextButton(
                      onPressed: ()  {
                        
                      },
                      child: Text(
                        "แชร์",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ))
                ],
              ),
            )
          ]),
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _bulidChild(context));
  }

  _bulidChild(BuildContext context) => CarouselSlider(
      options: CarouselOptions(
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          aspectRatio: 1,
          autoPlay: false),
      items: dialogList);

  Widget wonOrNot(Map<String, dynamic> value, BuildContext context) {
    if (value['status'] == "true") {
      boxColor = Colors.blueAccent;
      return displayData(value['usernumber'], value['name'], value['date'],
          "ถูกรางวัล", 20, Colors.amber);
    } else {
      boxColor = Colors.grey;
      return displayData(value['usernumber'], value['name'], value['date'],
          "ไม่ถูกรางวัล", 30, Colors.blueGrey[600]);
    }
    // return data;
  }

  Widget displayData(String usernumber, String name, String date, String won,
      double size, Color color) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, //Center Column contents vertically,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("หมายเลข  "),
            Text(usernumber,
                style: TextStyle(fontSize: 24, color: Colors.white)),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          won,
          style: TextStyle(fontSize: size, color: color),
        ),
        name.isNotEmpty
            ? Text(name, style: TextStyle(fontSize: 30, color: Colors.red))
            : SizedBox(
                height: 24,
              ),
        SizedBox(
          height: 20,
        ),
        Text("งวดที่ $date",
            style: TextStyle(fontSize: 18, color: Colors.black)),
      ],
    );
  }
}
