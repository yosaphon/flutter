import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowCheckImage extends StatelessWidget {
  final String date;
  String imageUrl;

  ShowCheckImage({this.date}) {
    print(date);
    imageUrl = "https://cdn.lottery.co.th/lotto/image/$date.jpg";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ใบตรวจฉลากกินแบ่งรัฐบาล",
          style: TextStyle(color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 0,
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
            children: [
              Icon(Icons.error),
              Text("เกิดข้อผิดพลาด")
            ],
          ),
        ),
      ),
    );
  }
}
