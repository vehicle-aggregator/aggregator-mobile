import 'package:aggregator_mobile/models/itinerary.dart';
import 'package:aggregator_mobile/models/user.dart';

class History{
  int id;
  Itinerary trip;
  List<Passenger> passengers;

  History.fromJson(Map<String, dynamic> json){
    this.id = json['ID'];
    this.trip = Itinerary.fromJson(json['Trip']);
    this.passengers = [];
    if (json['Passengers'] != null){
      json['Passengers'].forEach((e) {
        this.passengers.add(Passenger.fromJson(e));
      });
    }
  }
}