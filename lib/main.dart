import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lotto/screen/displaylotto.dart';
import 'package:lotto/screen/formshowlotto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lottery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Lottery app'),
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            children: [DisplayScreen(), Container(), Container(), Formshowlotto()],
          ),
          backgroundColor: Colors.blue,
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(text: "หน้าแรก", icon: Icon(Icons.home)),
              Tab(text: "ตรวจรางวัล", icon: Icon(Icons.fact_check_rounded)),
              Tab(text: "ใบ้รางวัล", icon: Icon(Icons.remove_red_eye_outlined)),
              Tab(text: "ผู้ใช้", icon: Icon(Icons.account_circle_outlined))
            ],
          ),
        ));
  }
}
