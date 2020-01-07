class ListNotifications {
   String id;
   String idtoperson;
   String idfromperson;
   String idevent;
   String title;
   String message;
   String confirmation;
  
  ListNotifications(
      {this.id,
      this.title,
      this.idtoperson,
      this.idfromperson,
      this.idevent,
      this.message,
      this.confirmation,
      });
}