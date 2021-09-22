import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/screen/check_login_user.dart';
import 'package:lotto/screen/display_predictor.dart';
import 'package:lotto/screen/display_youtubelive.dart';
import 'package:lotto/screen/displaycheck.dart';
import 'package:lotto/screen/displaylotto.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return PrizeNotifier();
        }),
        ChangeNotifierProvider(create: (context) {
          return UserNotifier();
        })
      ],
      child: MaterialApp(
        title: 'Lottery',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Lottery app'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectIndex = 0;
  final scren = [
    DisplayScreen(),
    Formqrcodescan(),
    DisplayLiveYoutube(),
    DispalyPredictor(),
    CheckLogInUser()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: selectIndex,
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue,
        backgroundColor: Colors.white60,
        animationCurve: Curves.easeInOut,
        items: <Widget>[
          // Tab(text: "หน้าแรก", icon:
          Icon(Icons.home,size: 30,),
          // Tab(text: "ตรวจสลาก", icon:
          Icon(Icons.qr_code_2,size: 30,),
          // Tab(text: "ถ่ายทอดสด", icon:
          FaIcon(FontAwesomeIcons.youtube,size: 30,),
          // Tab(text: "ใบ้รางวัล", icon:
          Icon(Icons.online_prediction,size: 30,),
          // Tab(text: "ผู้ใช้", icon:
          Icon(Icons.account_circle_outlined,size: 30,)
        ],
        onTap: (index) {
          setState(() {
            selectIndex = index;
          });
        },
      ),
      body: scren[selectIndex],
    );
    // return DefaultTabController(
    //     length: 5,
    //     child: Scaffold(
    //       body: TabBarView(
    //         physics: NeverScrollableScrollPhysics(),
    //         children: [
    //           DisplayScreen(),
    //           Formqrcodescan(),
    //           DisplayLiveYoutube(),
    //           DispalyPredictor(),
    //           CheckLogInUser()
    //         ],
    //       ),
    //       backgroundColor: Colors.blue,
    //       bottomNavigationBar: TabBar(
    //         labelStyle: TextStyle(fontSize: 10.0),
    //         labelColor: Color(0xffffffff), // สีของข้อความปุ่มที่เลือก

    //         unselectedLabelColor:
    //             Color(0x55ffffff), // สีของข้อความปุ่มที่ไม่ได้เลือก
    //         tabs: [
    //           Tab(text: "หน้าแรก", icon: Icon(Icons.home)),
    //           Tab(text: "ตรวจสลาก", icon: Icon(Icons.qr_code_2)),
    //           Tab(text: "ถ่ายทอดสด", icon: FaIcon(FontAwesomeIcons.youtube)),
    //           Tab(text: "ใบ้รางวัล", icon: Icon(Icons.online_prediction)),
    //           Tab(text: "ผู้ใช้", icon: Icon(Icons.account_circle_outlined))
    //         ],
    //       ),
    //     ));
  }
}
