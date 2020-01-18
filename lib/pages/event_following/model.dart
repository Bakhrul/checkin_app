import 'package:flutter/material.dart';

class ListFollowingEvent {
   String id;
   String image;
   String title;
   String waktuawal;
   String waktuakhir;
   String fullday;  
   String alamat;
   String wishlist;
   String idcreator;
   String statusdaftar;
   String posisi;
   String follow;
   String creatorName;
   Color color;
   String status;

  ListFollowingEvent(
      {this.id,
      this.title,
      this.image,
      this.waktuawal,
      this.waktuakhir,
      this.alamat,
      this.fullday,
      this.wishlist,
      this.idcreator,
      this.statusdaftar,
      this.follow,
      this.status,
      this.creatorName,
      this.color,
      this.posisi});
}

class ListKategoriEvent {
   String id;
   String nama;
   bool color;
  
  ListKategoriEvent(
      {this.id,
      this.nama,
      this.color
      });
}
