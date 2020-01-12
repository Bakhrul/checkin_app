class ListOngoingEvent {
   String id;
   String title;
   String waktuawal;
   String waktuakhir;
   String fullday;  
   String deskripsi;
   String lokasi;
   String status;
  ListOngoingEvent(
      {this.id,
      this.title,
      this.waktuawal,
      this.waktuakhir,
      this.deskripsi,
      this.lokasi,
      this.fullday,
      this.status});
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
  
  ListWillComeEvent(
      {this.id,
      this.title,
      this.waktuawal,
      this.waktuakhir,
      this.deskripsi,
      this.lokasi,
      this.fullday,
      this.status});
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
  
  ListDoneEvent(
      {this.id,
      this.title,
      this.waktuawal,
      this.waktuakhir,
      this.deskripsi,
      this.lokasi,
      this.fullday,
      this.status});
}
class ListUser {
   String id;
   String nama;
   String email;
  
  ListUser(
      {this.id,
      this.nama,
      this.email,
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
   String email;
   String posisi;
   String status;
   
  
  ListPesertaEvent(
      {this.idevent,
      this.idpeserta,
      this.nama,
      this.email,
      this.posisi,
      this.status,
      });
}

class ListAdminEvent {
   String idevent;
   String idpeserta;
   String nama;
   String email;
   String posisi;
   String status;
   
  
  ListAdminEvent(
      {this.idevent,
      this.idpeserta,
      this.nama,
      this.email,
      this.posisi,
      this.status,
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


