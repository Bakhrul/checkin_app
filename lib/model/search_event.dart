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
    bool expired;
    String creatorName;
    String follow;

  SearchEvent({
      this.follow,
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
      this.position,
      this.expired,
      this.creatorName
  });

  factory SearchEvent.fromJson(Map<String, dynamic> map){
      
      Duration dif = DateTime.parse(map['ev_time_end']).difference(DateTime.now());
      DateTime yearStart = DateTime.parse(map['ev_time_start']);
      DateTime yearEnd = DateTime.parse(map['ev_time_end']);
      String cekAllday = map['ev_allday'];
      String formatStart = yearStart.year == yearEnd.year ? cekAllday == 'N' ? "dd MMM yyyy H:m" : 'dd MMM' : cekAllday == 'N' ? "dd MMM yyyy H:m" : 'dd MMM';
      String formatEnd = yearStart.year == yearEnd.year ? cekAllday == 'N' ? "H:m" : 'dd MMM yyyy' : cekAllday == 'N' ? "H:m" : 'dd MMM yyyy';
      String dateStart = DateFormat(formatStart).format(DateTime.parse(map['ev_time_start']));
      String dateEnd = DateFormat(formatEnd).format(DateTime.parse(map['ev_time_end']));      
      String hours = DateFormat("H:ms").format(DateTime.parse(map['ev_time_start']));
      String status;
      Color color;

      if(dif.inSeconds <= 0){

        status = 'Event Selesai';
        color = Color.fromRGBO(255, 191, 128,1);

      }else if(map['ep_position'] != 2){

        switch(map['ep_status']){
        case 'C':
             status = 'Pendaftarn Ditolak';
             color = Colors.red;
             break;
        case 'P':
             status = 'Menunggu Verifikasi';
             color = Colors.orange;
             break;
        case 'A':
             status = 'Sudah Terdaftar';
             color = Colors.green;
             break;
        case 'B':
             status = 'Dilarang Mendaftar Event';
             color = Colors.red;
             break;
        default:
             status = 'Belum Terdaftar';
             color = Colors.grey;
             break;
        }

      }else{

        switch(map['ep_status']){
        case 'C':
             status = 'Belum Terdaftar';
             color = Colors.grey;
             break;
        case 'P':
             status = 'Belum Konfirmasi Admin';
             color = Colors.orange;
             break;
        case 'B':
             status = 'Dilarang Mendaftar Event';
             color = Colors.red;
             break;

        default:
           status = 'Admin / Co-Host';
           color = Colors.green;
           break;

        }

        

      }
      return SearchEvent(
        id:map['ev_id'],
        title:map['ev_title'],
        location:map['ev_location'],
        creatorName:map['us_name'],
        detail:map['ev_detail'],
        allday:map['ev_allday'],
        image:map['ev_image'],
        start:dateStart,
        end:dateEnd,
        hour:hours,
        statusRegistered:status,
        color:color,
        expired: dif.inSeconds <= 0 ? true:false,
        wish:map['ew_wish'],
        userWish:map['ew_user_id'],
        follow:map['fo_status'] == null ? "N":map['fo_status'],
        userEvent:map['ev_create_user'],
        position:map['ep_position']
      );
  }

    List<SearchEvent> searchEventFromJson(String jsonData){
        final data = json.decode(jsonData);
        return List<SearchEvent>.from(data['data'].map((i)=> SearchEvent.fromJson(i)));
    }
  }