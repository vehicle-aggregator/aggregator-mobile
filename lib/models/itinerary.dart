class Itinerary{
  String from;
  String to;
  String transporter;
  int departureTime;
  int arrivalTime;
  double price;
  int quantity;
  DateTime date;
  int vacantQuantity;

  Itinerary({this.arrivalTime, this.date, this.departureTime, this.from, this.price, this.quantity, this.to, this.transporter, this.vacantQuantity});

  Itinerary.test(){
    this.arrivalTime = 10000000;
    this.departureTime = 76400000;
    this.from = 'Владимир';
    this.to = 'Москва';
    this.transporter = 'ВладПассТранс';
    this.quantity = 52;
    this.price = 3050.00;
    this.vacantQuantity = 11;
    this.date = DateTime.now();
  }
}