import 'package:aggregator_mobile/network/endpoints.dart';
import 'package:aggregator_mobile/network/rest_client.dart';

class BalanceClient{
  RestClient _client = RestClient();


  Future<bool> changeBalance(int sum) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = sum;
    var json = await _client.post(Endpoints.balance, data);
    return json['Balance'] != null;
  }
}