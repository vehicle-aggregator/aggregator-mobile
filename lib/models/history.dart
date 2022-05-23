import 'package:aggregator_mobile/models/itinerary.dart';
import 'package:aggregator_mobile/models/ticket.dart';
import 'package:aggregator_mobile/models/user.dart';

class History{
  int id;
  Itinerary trip;
  List<Passenger> passengers;
  List<Ticket> tickets;

  History.fromJson(Map<String, dynamic> json){
    this.id = json['ID'];
    this.trip = Itinerary.fromJson(json['Trip']);
    this.passengers = [];
    if (json['Passengers'] != null){
      json['Passengers'].forEach((e) {
        this.passengers.add(Passenger.fromJson(e));
      });
    }


    this.tickets = [];
    if (json['BusPlace'] != null) {
      this.tickets.add(Ticket.fromJson(json));
    }
    if (json['SideTicket'] != null){
      json['SideTicket'].forEach((e) {
        this.tickets.add(Ticket.fromJson(e));
      });
    }
  }
}