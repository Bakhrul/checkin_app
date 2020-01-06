import "dart:convert";
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class SearchEvent{

    int id;
    String title;
    String location;
    String detail;
    String allday;
    String start;
    String end;
    int user;
    String hour;
    String wish;
    int wishId;
    String statusRegistered;
    Color color;

  SearchEvent({
      this.id,
      this.title,
      this.location,
      this.detail,
      this.allday,
      this.start,
      this.end,
      this.hour,
      this.user,
      this.wish,
      this.wishId,
      this.statusRegistered,
      this.color
  });

  factory SearchEvent.fromJson(Map<String, dynamic> map){

      String dateStart = DateFormat("dd MMM").format(DateTime.parse(map['ev_time_start']));
      String dateEnd = DateFormat("dd MMM yyyy").format(DateTime.parse(map['ev_time_end']));
      String hours = DateFormat("Hm:ms").format(DateTime.parse(map['ev_time_start']));
      String status;
      Color color;

      switch(map['ep_status']){
        case 'b':
             status = 'belum terdaftar';
             color = Colors.grey;
             break;
        case 'p':
             status = 'proses';
             color = Colors.orange;
             break;
        case 's':
             status = 'sudah terdaftar';
             color = Colors.green;
             break;
        default:
             status = 'belum terdaftar';
             color = Colors.grey;
             break;
      }

      return SearchEvent(
        id:map['ev_id'],
        title:map['ev_title'],
        location:map['ev_location'],
        detail:map['ev_detail'],
        allday:map['ev_allday'],
        start:dateStart,
        end:dateEnd,
        hour:hours,
        statusRegistered:status,
        color:color,
        wish:map['ew_wish'],
        user:map['ew_user_id']
      );
  }

    List<SearchEvent> searchEventFromJson(String jsonData){
        final data = json.decode(jsonData);
        return List<SearchEvent>.from(data['data'].map((i)=> SearchEvent.fromJson(i)));
    }
  }