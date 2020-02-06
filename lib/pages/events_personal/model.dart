class ListOngoingEvent {
   String id;
   String title;
   String waktuawal;
   String waktuakhir;
   String fullday;  
   String deskripsi;
   String lokasi;
   String status;
   String publish;
  ListOngoingEvent(
      {this.id,
      this.title,
      this.waktuawal,
      this.waktuakhir,
      this.deskripsi,
      this.lokasi,
      this.fullday,
      this.status,
      this.publish});
}

class ListMoreMyEvent {
   String id;
   String title;
   String waktuawal;
   String waktuakhir;
   String fullday;  
   String deskripsi;
   String lokasi;
   String status;
   String publish;
  ListMoreMyEvent(
      {this.id,
      this.title,
      this.waktuawal,
      this.waktuakhir,
      this.deskripsi,
      this.lokasi,
      this.fullday,
      this.status,
      this.publish});
}

class ListWillComeEvent {
   String id;
   String title;
   String waktuawal;
   String waktuakhir;
   String fullday;  
   String deskripsi;
   String lokasi;
   String status;
   String publish;
  
  ListWillComeEvent(
      {this.id,
      this.title,
      this.waktuawal,
      this.waktuakhir,
      this.deskripsi,
      this.lokasi,
      this.fullday,
      this.status,
      this.publish});
}

class ListDoneEvent {
   String id;
   String title;
   String waktuawal;
   String waktuakhir;
   String fullday;  
   String deskripsi;
   String lokasi;
   String status;
   String publish;
  
  ListDoneEvent(
      {this.id,
      this.title,
      this.waktuawal,
      this.waktuakhir,
      this.deskripsi,
      this.lokasi,
      this.fullday,
      this.status,
      this.publish});
}
class ListUser {
   String id;
   String nama;
   String email;
   String image;
  
  ListUser(
      {this.id,
      this.nama,
      this.email,
      this.image,
      });
}

class ListUserAdd {
   String id;
   String nama;
   String email;
  
  ListUserAdd(
      {this.id,
      this.nama,
      this.email,
      });
}

class ListCheckinAdd {
   String keyword;
   String nama;
   String timestart;
   String timeend;
  
  ListCheckinAdd(
      {this.keyword,
      this.nama,
      this.timestart,
      this.timeend,
      });
}

class ListKategoriEvent {
   String id;
   String nama;
   
  
  ListKategoriEvent(
      {this.id,
      this.nama,
      });
}

class ListKategoriEventAdd {
   String id;
   String nama;
   
  
  ListKategoriEventAdd(
      {this.id,
      this.nama,
      });
}

class ListCheckinEvent {
   String idevent;
   String id;
   String name;
   String code;
   String timestart;
   String timeend;
   String typecheckin;
   String checkin;
   
  
  ListCheckinEvent(
      {this.idevent,
      this.id,
      this.name,
      this.code,
      this.timestart,
      this.timeend,
      this.typecheckin,
      this.checkin,
      });
}
class ListPesertaEvent {
   String idevent;
   String idpeserta;
   String nama;
   String image;
   String email;
   String posisi;
   String status;
   String updateAt;
   
  
  ListPesertaEvent(
      {this.idevent,
      this.idpeserta,
      this.nama,
      this.email,
      this.posisi,
      this.status,
      this.image,
      this.updateAt,
      });
}

class ListAdminEvent {
   String idevent;
   String idpeserta;
   String nama;
   String email;
   String posisi;
   String status;
   String image;
   
  
  ListAdminEvent(
      {this.idevent,
      this.idpeserta,
      this.nama,
      this.email,
      this.posisi,
      this.status,
      this.image,
      });
}

class ListCheckinUsers {
   String idcheckin;
   String idpeserta;
   String namapeserta;
   String idevent;
   String emailpeserta;
   String statuscheckin;
   
  ListCheckinUsers(
      {this.idcheckin,
      this.idevent,
      this.idpeserta,
      this.namapeserta,
      this.statuscheckin,
      this.emailpeserta,
      });
}

class ListEditKategoriEvent {
   String id;
   String nama;
   
  ListEditKategoriEvent(
      {this.id,
      this.nama,
      });
}

class ListPointCheckin {
   String idpeserta;
   String namapeserta;
   String image;
   String jumlahcheckinevent;
   String jumlahcheckinpeserta;
   String persencheckin;
   
  ListPointCheckin(
      {this.idpeserta,
      this.namapeserta,
      this.jumlahcheckinevent,
      this.jumlahcheckinpeserta,
      this.persencheckin,
      this.image,
      });
}


class LisMultiCheckinUser {
   String idpeserta;
   String email;
   String nama;
   String image;
   List listcheckin;
  LisMultiCheckinUser(
      {this.email,
      this.nama,
      this.idpeserta,
      this.image,
      this.listcheckin,
      });
}

class ListUserCheckins {
   String keyword;
   String userId;
   String ucTime;
   String idCheckin;
  ListUserCheckins(
      {this.keyword,
      this.userId,
      this.ucTime,
      this.idCheckin,
      });
}


