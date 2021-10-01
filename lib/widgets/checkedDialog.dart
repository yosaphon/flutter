
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:footer/footer.dart';
import 'package:lotto/model/dropdownDate.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

import 'package:share/share.dart';

class CheckedDialog extends StatelessWidget {
  final Map<int, Map<String, dynamic>> data;
  final BuildContext context;
  GlobalKey _key = GlobalKey();
  Color boxColor1, boxColor2;
  List<Widget> dialogList = [];

  CheckedDialog(this.data, this.context) {
    // data.forEach((key, value) {
    //   Widget result = wonOrNot(value, context);
    //   dialogList.add(shareAndClose(
    //     result,
    //     convertWidgetToImage(_key, context),
    //   ));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(0),
        elevation: 0,
        child: _bulidChild(context));
  }

  _bulidChild(BuildContext context) => RepaintBoundary(
        key: _key,
        child: CarouselSlider(
            options: CarouselOptions(
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                aspectRatio: 1,
                autoPlay: false),
            items: dialogList),
      );

}

Widget displayData(String usernumber, String name, String date, bool status,
    double size, Color color) {
  return Column(
    children: <Widget>[
     Container(
        child:(status) ? Image.asset('asset/happy.gif'):Image.asset('asset/sad.gif'),
      ),
      Row(
        mainAxisAlignment:
            MainAxisAlignment.center, //Center Column contents vertically,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("หมายเลข  "),
          Text(usernumber,
              style: TextStyle(fontSize: 24, color: Colors.indigo)),
        ],
      ),
      (status)
          ? Text(
              "ถูก",
              style: TextStyle(fontSize: size, color: color),
            )
          : Text(
              "ไม่ถูกรางวัลใดๆ",
              style: TextStyle(fontSize: size, color: color),
            ),
      name.isNotEmpty
          ? Text(name, style: TextStyle(fontSize: 30, color: Colors.red[400]))
          : SizedBox(
              height: 24,
            ),
      Text("งวดที่ ${ numToWord(date)}" ,
          style: TextStyle(fontSize: 18, color: Colors.black)),
    ],
  );
}

Widget shareAndClose(result, context,_key) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blueAccent,
              Colors.pink,
            ],
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(children: [
          Column(
            children: [
              result,
            ],
          ),
          Footer(
            backgroundColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
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
                      onPressed: () {
                        convertWidgetToImage(_key,context);
                      },
                      child: Text(
                        "แชร์",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ))
                ],
              ),
            ),
          )
        ]),
      ),
    ),
  );
}

convertWidgetToImage(_key, context) async {
  try {
    List<String> imagePath = [];
    RenderRepaintBoundary renderRepaintBoundary =
        _key.currentContext.findRenderObject();
    ui.Image boxImgae = await renderRepaintBoundary.toImage(pixelRatio: 2);
    final directory = (await getExternalStorageDirectory()).path;
    ByteData byteData =
        await boxImgae.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData.buffer.asUint8List();
    print(uint8list);
    File imgFile = new File('$directory/resultChecked.png');
    imgFile.writeAsBytes(uint8list);
    imagePath.add(imgFile.path);
    final RenderBox box = context.findRenderObject();
    Share.shareFiles(imagePath,
        subject: 'Share Lottery',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  } on PlatformException catch (e) {
    print("Exception while taking screenshot:" + e.toString());
  }
}
