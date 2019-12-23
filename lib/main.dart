import 'package:checkin_app/pages/events_all/index.dart';
import 'package:flutter/material.dart';

//pages
import 'dashboard.dart';
import 'pages/events_all/index.dart';
import 'pages/events_all/index_z.dart';
import 'pages/events_personal/index.dart';
import 'pages/check_in/check_in.dart';
import 'pages/check_in/count_down.dart';
import 'splash_screen.dart';
import 'pages/check_in/tes.dart';

Map<String, WidgetBuilder> routesX = <String, WidgetBuilder>{
  "/dashboard": (BuildContext context) => Dashboard(),
  "/semua_event" : (BuildContext context) => ManajemenEvent(),
  "/personal_event" : (BuildContext context) => ManajemenEventPersonal(),
  "/check_in" : (BuildContext context) => CheckIn(),
  "/count_down" : (BuildContext context) => CountDown(),
  "/tes" : (BuildContext context) => Tes(),
  "/index_z" : (BuildContext context) => EventAll()
};
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: SplashScreen(),
      routes: routesX,
    );
  }
}