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
   String namafromperson;
   String namatoperson;
   String namaupdateperson;
   String idmessage;
   String statusRead;
   String namaCreator;
   String namaEvent;
   String messageCustom;
  
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
      this.namafromperson,
      this.namatoperson,
      this.idmessage,
      this.namaupdateperson,
      this.statusRead,
      this.namaCreator,
      this.namaEvent,
      this.messageCustom,
      });
}