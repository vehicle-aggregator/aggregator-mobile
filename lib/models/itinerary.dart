import 'dart:math';

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
    int randomNumber = Random().nextInt(3) + 1;

    this.arrivalTime = 10000000;
    this.departureTime = 76400000;


    switch (randomNumber){
      case 1:
        this.from = 'Владимир';
        break;
      case 2:
        this.from = 'Ковров';
        break;
      case 3:
        this.from = 'Александров';
        break;
    }

    randomNumber = Random().nextInt(3) + 1;
    switch (randomNumber){
      case 1:
        this.to = 'Муром';
        break;
      case 2:
        this.to = 'Суздаль';
        break;
      case 3:
        this.to = 'Вязники';
        break;
    }

    var r = Random().nextInt(3);
    switch (r){
      case 0:
        this.transporter = 'Компания1';
        break;
      case 1:
        this.transporter = 'ЫЫЫ.com';
        break;
      case 2:
        this.transporter = 'Ну че народ, погнали...';
        break;
    }


    this.quantity = 52;
    var random = Random().nextInt(1900) + 100;
    this.price = random.toDouble();
    this.vacantQuantity = 11;
    this.date = DateTime.now().add(Duration(days: Random().nextInt(4)));
  }

  Itinerary.fromJson(Map<String, dynamic> json){
    //this.from = json['']
  }
}