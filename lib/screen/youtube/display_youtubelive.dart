
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lotto/api/prize_api.dart';
import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/notifier/prize_notifier.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayLiveYoutube extends StatefulWidget {
  @override
  _DisplayLiveYoutubeState createState() => _DisplayLiveYoutubeState();
}

class _DisplayLiveYoutubeState extends State<DisplayLiveYoutube> {
  @override
  void initState() {
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);
    getPrize(prizeNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: true);
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Color(0xFFF3FFFE),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ลิงค์ถ่ายทอดสด",
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: getPrize(prizeNotifier),
        builder: (context, snapshot) {
          if (prizeNotifier.prizeList.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                    child: Text(
                      "วิดิโอการออกรางวัล",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: prizeNotifier.prizeList.values.map((document) {
                      String url = document.youtubeUrl;
                      String id = url.substring(url.length - 11);
                      String urlThumnail =
                          "https://img.youtube.com/vi/" + id + "/0.jpg";
                      return cardContainer(
                          url: document.youtubeUrl,
                          listTile: ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                RichText(text:TextSpan(children: [TextSpan(text: "วันที่ ",style: TextStyle(fontFamily: "Mitr" ,color: Colors.black ,fontSize: 14)),
                                TextSpan(text: "${numToWord(document.date)} ",style: TextStyle(fontFamily: "Mitr" ,color: Colors.orange,fontSize: 18)),
                                ]) ),
                                document.status != 1? Text("กำลังถ่ายทอดสด" ,style: TextStyle(color: Colors.red)):Text("")
                              ],
                            ),
                            subtitle: Text(
                                "งวดที่ ${document.period[0]},${document.period[1]}" ,style: TextStyle(color: Colors.indigo),),
                          ),
                          image: Image.network('$urlThumnail',height: 150,
                        fit:BoxFit.cover));
                    }).toList(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

Widget cardContainer({image, listTile, url}) {
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20),
    child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: InkWell(
        onTap: () async {
          if (await canLaunch(url)) {
            await launch(url);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: image,
            ),
            listTile,
          ],
        ),
      ),
    ),
    decoration: new BoxDecoration(
        boxShadow: [
          BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 9,
                  offset: Offset(0, 1), // changes position of shadow
                ),
        ],
      ),
  );
}
