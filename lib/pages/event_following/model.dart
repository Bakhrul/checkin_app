class ListFollowingEvent {
   String id;
   String image;
   String title;
   String waktuawal;
   String waktuakhir;
   String fullday;  
   String alamat;
   String wishlist;
   String statusdaftar;

  ListFollowingEvent(
      {this.id,
      this.title,
      this.image,
      this.waktuawal,
      this.waktuakhir,
      this.alamat,
      this.fullday,
      this.wishlist,
      this.statusdaftar});
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
