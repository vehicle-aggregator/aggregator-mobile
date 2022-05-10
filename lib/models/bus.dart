class Bus {
  List<Seat> seats;

  Bus(this.seats);

  Bus.fromJson(List<dynamic> json){

    List<Seat> seats = [];
    json.forEach((value) {
      seats.add(Seat.fromJson(value));
    });
    this.seats = seats;
  }
}

class Seat{
  int id;
  int number;
  int row;
  int column;
  bool show;
  bool busy;
  String status;

  Seat({this.status,this.number,this.id,this.busy,this.column, this.row, this.show});

  Seat.fromJson(Map<String, dynamic> json){
    print('++++++++++++++++++++++ $json');
    this.id = json['ID'];
    this.show = json['Show'];
    this.busy = json['Busy'];
    this.status = this.busy ? 'engaged' : 'vacant';
    this.row = json['BusPlace']['BusRaw'];
    this.column = json['BusPlace']['BusColumn'];
    this.number = json['BusPlace']['PlaceNum'];
  }
}

