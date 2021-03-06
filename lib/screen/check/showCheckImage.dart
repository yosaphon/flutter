// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class ShowCheckImage extends StatelessWidget {
  final String date;
  String imageUrl;
  List<String> nDate = [];
  String y;

  ShowCheckImage({this.date}) {
    print(date);
    nDate = date.split("-");
    y = (int.parse(nDate[0]) + 543).toString();
    y = y.substring(2, 4);
    print(y + nDate[1] + nDate[2]);
    y = y + nDate[1] + nDate[2];
    imageUrl = "https://cdn.lottery.co.th/lotto/image/$y.jpg";
    print(y);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ใบตรวจฉลากกินแบ่งรัฐบาล",
          style: TextStyle(color: Colors.indigo),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.white, //withOpacity(0.1),
        elevation: 0,
        iconTheme: IconThemeData(
    color: Colors.black, //change your color here
  ),
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => Container(
            child: PhotoView(
              imageProvider: imageProvider,
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Row(
            children: [Column(
              children: [
                Icon(Icons.error),
              ],
            ), Text("เกิดข้อผิดพลาด")],
          ),
        ),
      ),
    );
  }
}
