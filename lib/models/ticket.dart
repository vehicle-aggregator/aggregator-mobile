class Ticket{
  int id;
  int row;
  int number;
  String code;

  Ticket.fromJson(Map<String, dynamic> json){
    this.id = json["ID"];
    this.row = json['BusPlace']['BusRaw'];
    this.number = json['BusPlace']['PlaceNum'];
    this.code = json['Code'];
  }
}