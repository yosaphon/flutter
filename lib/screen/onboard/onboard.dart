import 'package:flutter/material.dart';
import 'package:lotto/main.dart';
import 'package:lotto/model/onboardModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  Color kblue = Color(0xFF4756DF);
  Color kwhite = Color(0xFFFFFFFF);
  Color kblack = Color(0xFF000000);
  Color indigo300 = Colors.indigo[300];
  Color indigo = Colors.indigo;
  int currentIndex = 0;
  PageController _pageController;
  List<OnboardModel> screens = <OnboardModel>[
    OnboardModel(
      img: 'asset/showprize.jpg',
      text: "ผลการออกรางวัล",
      desc:
          "สามารถดูผลการออกรางวัลในงวดปัจจุบันและสามารถดูผลกการออกรางวัลย้อนหลังได้",
      bg: Colors.white,
      button: Color(0xFF4756DF),
    ),
    OnboardModel(
      img: 'asset/showyoutube.jpg',
      text: "ลิงค์ดูการออกสลากกินแบ่ง",
      desc: "สามารถเปิดดูการถ่ายทอดสดในปัจจุบันและอดีตได้",
      bg: Color(0xFF4756DF),
      button: Colors.white,
    ),
    OnboardModel(
      img: 'asset/showcheck.jpg',
      text: "ตรวจผลรางวัล",
      desc: "สามารถตรวจรางวัลด้วยการ สแกน QR Code หรือ กรอกเลขตรวจได้",
      bg: Color(0xFF4756DF),
      button: Colors.white,
    ),
    OnboardModel(
      img: 'asset/showprediction.jpg',
      text: "ดูการใบ้รางวัล",
      desc: "สามารถดูเลขเด็ดของงวดต่อไปได้",
      bg: Color(0xFF4756DF),
      button: Colors.white,
    ),
    OnboardModel(
      img: 'asset/showuser.jpg',
      text: "บันทึกสลาก",
      desc:
          "สามารถบันทึกสลากก่อนออกรางวัลได้และเมือรางวัลออกระบบจะส่งแจ้งเตือนไปยังมือถือ",
      bg: Colors.white,
      button: Color(0xFF4756DF),
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _storeOnboardInfo() async {
    print("Shared pref called");
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    print(prefs.getInt('onBoard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FFFE),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              _storeOnboardInfo();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
            child: Text(
              "Skip",
              style: TextStyle(
                color: kblack,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PageView.builder(
            itemCount: screens.length,
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    screens[index].img,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.6,
                  ),
                  Container(
                    height: 10.0,
                    child: ListView.builder(
                      itemCount: screens.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 3.0),
                                width: currentIndex == index ? 25 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? indigo
                                      : indigo300,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ]);
                      },
                    ),
                  ),
                  Text(
                    screens[index].text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.w400,
                      color: kblack,
                    ),
                  ),
                  Text(
                    screens[index].desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: kblack,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      print(index);
                      if (index == screens.length - 1) {
                        await _storeOnboardInfo();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      }

                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                      decoration: BoxDecoration(
                          color: kblue,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          index == screens.length - 1
                              ? "เริ่มต้นใช้งาน"
                              : "Next",
                          style: TextStyle(fontSize: 16.0, color: kwhite),
                        ),
                        index == screens.length - 1
                            ? SizedBox()
                            : SizedBox(
                                width: 15.0,
                              ),
                        index == screens.length - 1
                            ? SizedBox()
                            : Icon(
                                Icons.arrow_forward_sharp,
                                color: kwhite,
                              )
                      ]),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
