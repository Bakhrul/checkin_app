class ListNotifications {
   String id;
   String idtoperson;
   String idfromperson;
   String idevent;
   String title;
   String message;
   String confirmation;
   String idcreator;
   String updatepeserta;
  
  ListNotifications(
      {this.id,
      this.title,
      this.idtoperson,
      this.idfromperson,
      this.idevent,
      this.message,
      this.confirmation,
      this.idcreator,
      this.updatepeserta,
      });
}