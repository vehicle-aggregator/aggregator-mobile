import 'package:aggregator_mobile/models/bus.dart';
import 'package:aggregator_mobile/models/user.dart';
import 'package:aggregator_mobile/network/endpoints.dart';
import 'package:aggregator_mobile/network/rest_client.dart';

class BookingClient {
  RestClient _client = RestClient();

  Future<Bus> fetchBus(int id) async {
    dynamic json = await _client.get('${Endpoints.bus}/$id');
    Bus a = Bus.fromJson(json);
    return a;
  }

  Future<bool> buyTicket(int tripId,  List<Seat> seats, List<Passenger> passengers) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tripID'] = tripId;
    data['places'] = [];
    seats.forEach((element) {
      data['places'] = [...data['places'], getId(element.id)];
    });
    data['passengers'] = [];
    passengers.forEach((element) {
      if (element.id != null)
        data['passengers'] = [...data['passengers'], getId(element.id)];
    });
    var json = await _client.postRaw(Endpoints.ticket, data);
    return json['ID'].toString() != null;
  }

  Map<String, dynamic> getId (id){
    return {
      'id': id,
    };
  }

// Map<String, dynamic> toJson({String password = ''}) {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['lastname'] = this.lastname;
//   data['name'] = this.name;
//   data['middlename'] = this.surname;
//   data['birthday'] = DateFormat("yyyy-MM-dd").format(this.birthDate);
//   data['coins'] = 0;
//   data['gender'] = this.gender;
//   data['email'] = this.email;
//   data['password'] = password;
//   return data;
// }
}