import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lotto/api/prize_api.dart';
import 'package:lotto/notification.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/notifier/sumary_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:lotto/screen/onboard/onboard.dart';
import 'package:lotto/screen/user/login/check_login_user.dart';
import 'package:lotto/screen/predict/display_predictor.dart';
import 'package:lotto/screen/youtube/display_youtubelive.dart';
import 'package:lotto/screen/check/displaycheck.dart';
import 'package:lotto/screen/prize/displaylotto.dart';
import 'package:flutter/services.dart';
import 'package:lotto/widgets/bottonTabBar.dart';
import 'package:lotto/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
int isviewed;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is used for important notifications.',
    importance: Importance.high);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard'); 
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
        title: 'Lottery Checky',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          fontFamily: 'Mitr',
        ),
        home: isviewed != 0 ? OnBoard() :Loader(),//MyHomePage(title: 'Lottery app'),
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
  @override
  void initState() {
    super.initState();
    getToken();

    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
      }
    });
  }

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
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);
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
          text: "????????????",
          // icon: Icon(Icons.qr_code_scanner)
        ),
        backgroundColor: Color(0xFFF63C4F),
        onPressed: () {
          if(prizeNotifier.prizeList.isNotEmpty){
             Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Formqrcodescan()),
          );
          }
         
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
