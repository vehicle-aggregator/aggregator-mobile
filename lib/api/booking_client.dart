import 'package:aggregator_mobile/models/bus.dart';
import 'package:aggregator_mobile/network/endpoints.dart';
import 'package:aggregator_mobile/network/rest_client.dart';

class BookingClient {
  RestClient _client = RestClient();

  Future<Bus> fetchBus(int id) async {
    dynamic json = await _client.get('${Endpoints.bus}/$id');
    Bus a = Bus.fromJson(json);
    return a;
  }

  Future buyTicket(int tripId, int placeId) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tripID'] = tripId;
    data['places'] = [getId(placeId)];
    var json = await _client.postRaw(Endpoints.ticket, data);
    print('RRREEESSSUUULLL^TTT==========> $json');
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