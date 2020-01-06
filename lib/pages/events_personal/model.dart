class ListOngoingEvent {
   String id;
   String title;
   String waktuawal;
   String waktuakhir;
   String fullday;  
  
  ListOngoingEvent(
      {this.id,
      this.title,
      this.waktuawal,
      this.waktuakhir,
      this.fullday});
}

class ListWillComeEvent {
   String id;
   String title;
   String waktuawal;
   String waktuakhir;
   String fullday;  
  
  ListWillComeEvent(
      {this.id,
      this.title,
      this.waktuawal,
      this.waktuakhir,
      this.fullday});
}

class ListDoneEvent {
   String id;
   String title;
   String waktuawal;
   String waktuakhir;
   String fullday;  
  
  ListDoneEvent(
      {this.id,
      this.title,
      this.waktuawal,
      this.waktuakhir,
      this.fullday});
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
   
  
  ListCheckinEvent(
      {this.idevent,
      this.id,
      this.name,
      this.code,
      this.timestart,
      this.timeend,
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


