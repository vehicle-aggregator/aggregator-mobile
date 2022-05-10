import 'package:aggregator_mobile/models/user.dart';
import 'package:aggregator_mobile/network/endpoints.dart';
import 'package:aggregator_mobile/network/rest_client.dart';
import 'package:intl/intl.dart';

class PassengerClient{
  RestClient _client = RestClient();


  Future<bool> addPassenger(Passenger item) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = item.name;
    data['lastname'] = item.lastname;
    data['middlename'] = item.surname;
    data['birthday'] = DateFormat("yyyy-MM-dd").format(item.birthDate);
    data['doctype'] = item.doctype == 'Паспорт' ? 0 : 1;
    data['docdetail'] = item.docdetail;
    var json = await _client.post(Endpoints.passenger, data);
    print('==========> $json');
    return json['ID'] != null;
  }
}