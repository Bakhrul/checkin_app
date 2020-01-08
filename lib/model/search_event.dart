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
    int userWish;
    String hour;
    String wish;
    int wishId;
    String statusRegistered;
    Color color;
    String userEvent;
    String image;
    String email;
    int position;

  SearchEvent({
      this.id,
      this.title,
      this.location,
      this.detail,
      this.allday,
      this.start,
      this.end,
      this.hour,
      this.userWish,
      this.wish,
      this.wishId,
      this.statusRegistered,
      this.color,
      this.userEvent,
      this.image,
      this.position
  });

  factory SearchEvent.fromJson(Map<String, dynamic> map){

      String dateStart = DateFormat("dd MMM").format(DateTime.parse(map['ev_time_start']));
      String dateEnd = DateFormat("dd MMM yyyy").format(DateTime.parse(map['ev_time_end']));
      String hours = DateFormat("H:ms").format(DateTime.parse(map['ev_time_start']));
      String status;
      Color color;
      String positionUser;

      switch(map['ep_position']){
        case 2:
           positionUser = 'Admin';
           break;
        default:
           positionUser = '';
           break;
      }

      switch(map['ep_status']){
        case 'C':
             status = 'Ditolak $positionUser';
             color = Colors.red;
             break;
        case 'P':
             status = 'Proses Daftar $positionUser';
             color = Colors.orange;
             break;
        case 'A':
             status = 'Sudah Terdaftar $positionUser';
             color = Colors.green;
             break;
        default:
             status = 'Belum Terdaftar $positionUser';
             color = Colors.grey;
             break;
      }

      return SearchEvent(
        id:map['ev_id'],
        title:map['ev_title'],
        location:map['ev_location'],
        detail:map['ev_detail'],
        allday:map['ev_allday'],
        image:map['ev_image'],
        start:dateStart,
        end:dateEnd,
        hour:hours,
        statusRegistered:status,
        color:color,
        wish:map['ew_wish'],
        userWish:map['ew_user_id'],
        userEvent:map['ev_create_user'],
        position:map['ep_position']
      );
  }

    List<SearchEvent> searchEventFromJson(String jsonData){
        final data = json.decode(jsonData);
        return List<SearchEvent>.from(data['data'].map((i)=> SearchEvent.fromJson(i)));
    }
  }