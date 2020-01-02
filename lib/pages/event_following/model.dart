class ListFollowingEvent {
   String id;
   String image;
   String title;
   String waktuawal;
   String waktuakhir;
   String fullday;  
   String alamat;
  
  ListFollowingEvent(
      {this.id,
      this.title,
      this.image,
      this.waktuawal,
      this.waktuakhir,
      this.alamat,
      this.fullday});
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
