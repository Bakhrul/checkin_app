class EventOrganizer {
   String id;
   String image;
   String title;
   String waktuawal;
   String waktuakhir;
   String fullday;  
   String alamat;
   String wishlist;
   String idcreator;
   String creatorName;
   String statusdaftar;
   String posisi;

  EventOrganizer(
      {this.id,
      this.title,
      this.creatorName,
      this.image,
      this.waktuawal,
      this.waktuakhir,
      this.alamat,
      this.fullday,
      this.wishlist,
      this.idcreator,
      this.statusdaftar,
      this.posisi});
}
