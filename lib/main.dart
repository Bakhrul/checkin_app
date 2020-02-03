import 'package:checkin_app/auth/register.dart';
import 'package:checkin_app/pages/events_all/index.dart';
import 'package:flutter/material.dart';

//pages
import 'auth/login.dart';
import 'dashboard.dart';
import 'pages/events_all/index.dart';
import 'pages/events_all/index_z.dart';
import 'pages/events_personal/index.dart';
import 'pages/check_in/check_in.dart';
import 'pages/check_in/count_down.dart';
import 'splash_screen.dart';
import 'pages/check_in/tes.dart';
import 'pages/event_following/index.dart';
import 'notifications/list_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:checkin_app/utils/notification_local.dart';

Map<String, WidgetBuilder> routesX = <String, WidgetBuilder>{
  "/dashboard": (BuildContext context) => Dashboard(),
  "/semua_event" : (BuildContext context) => ManajemenEvent(),
  "/personal_event" : (BuildContext context) => ManajemenEventPersonal(),
  "/check_in" : (BuildContext context) => CheckIn(),
  "/count_down" : (BuildContext context) => CountDown(),
  "/tes" : (BuildContext context) => Tes(),
  "/index_z" : (BuildContext context) => EventAll(),
  "/login" : (BuildContext context) => LoginPage(),
  "/register" : (BuildContext context) => Register(),
  "/follow_event" : (BuildContext context) => ManajemenEventFollowing(),
  "/notifications" : (BuildContext context) => ManajemenNotifications(),
};

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  MyApp({Key key}) : super(key: key);

  State<StatefulWidget> createState() {
    return _MyApp();
  }
}
String _message;
class _MyApp extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  NotificationLocal notif = new NotificationLocal();


  // This widget is the root of your application.
  // Platform messages are asynchronous, so we initialize in an async method.
  @override
  void initState(){
    notif.mustInit(); 
    _message = '';
    getMessage();
    register();
    super.initState();
  }

   register() {
    _firebaseMessaging.getToken().then((token) => print(token));
  }

  void getMessage(){

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
          notif.showNotificationWithSound(message["notification"]["title"],message["notification"]["body"]);
          print('on message $message');
          setState(() {
            _message = message["notification"]["title"];
          });
    }, onResume: (Map<String, dynamic> message) async {
          print('on resume $message');
          setState(() {
            _message = message["notification"]["title"];
          });
    }, onLaunch: (Map<String, dynamic> message) async {
          print('on launch $message');
          setState(() {
            _message = message["notification"]["title"];
          });
    });

  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventZhee',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: routesX,
    );
  }
}