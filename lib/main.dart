import 'package:checkin_app/pages/events_all/index.dart';
import 'package:flutter/material.dart';

//pages
import 'dashboard.dart';
import 'pages/events_all/index.dart';
import 'pages/event_follow/index.dart';
import 'pages/events_personal/index.dart';

Map<String, WidgetBuilder> routesX = <String, WidgetBuilder>{
  "/dashboard": (BuildContext context) => Dashboard(),
  "/semua_event" : (BuildContext context) => ManajemenEvent(),
  "/follow_event" : (BuildContext context) => ManajemeEventFollow(),
  "/personal_event" : (BuildContext context) => ManajemenEventPersonal(),
};
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
      home: Dashboard(),
      routes: routesX,
    );
  }
}