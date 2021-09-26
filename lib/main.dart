import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lotto/api/prize_api.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/notifier/sumary_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/screen/check_login_user.dart';
import 'package:lotto/screen/display_predictor.dart';
import 'package:lotto/screen/display_youtubelive.dart';
import 'package:lotto/screen/displaycheck.dart';
import 'package:lotto/screen/displaylotto.dart';
import 'package:flutter/services.dart';
import 'package:lotto/widgets/bottonTabBar.dart';
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
        }),
        ChangeNotifierProvider(create: (context) {
          return UserSumaryNotifier();
        })
      ],
      child: MaterialApp(
        title: 'Lottery',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Mitr',
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
  int index = 0;
  final pages = <Widget>[
    DisplayScreen(),
    DisplayLiveYoutube(),
    DispalyPredictor(),
    CheckLogInUser()
  ];
  void onChangedTab(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    PrizeNotifier prizeNotifier = Provider.of<PrizeNotifier>(context);
    getPrize(prizeNotifier);

    return Scaffold(
      extendBody: true,
      body: pages[index],
      bottomNavigationBar: TabBarMaterialWidget(
        index: index,
        onChangedTab: onChangedTab,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        child: Tab(
          text: "ตรวจ",
          // icon: Icon(Icons.qr_code_scanner)
        ),
        backgroundColor: Color(0xFFF63C4F),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Formqrcodescan()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
