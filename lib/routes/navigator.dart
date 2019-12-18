import 'package:flutter/material.dart';

class MyNavigator{
  static void goToDashboard(BuildContext context){
    Navigator.pushNamed(context, "/dashboard");
  }
  static void goToAllEvent(BuildContext context){
    Navigator.pushNamed(context, "/semua_event");
  }
  static void goToFollowEvent(BuildContext context){
    Navigator.pushNamed(context, "/follow_event");
  }
  static void goToPersonalEvent(BuildContext context){
    Navigator.pushNamed(context, "/personal_event");
  }
}