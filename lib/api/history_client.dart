import 'package:aggregator_mobile/models/history.dart';
import 'package:aggregator_mobile/network/endpoints.dart';
import 'package:aggregator_mobile/network/rest_client.dart';

class HistoryClient{
  RestClient _client = RestClient();

  Future<List<History>> fetchHistory() async {
    dynamic json = await _client.get(Endpoints.history);
    List<History> a = [];
    print('KKKKKKKKKKKKKKKKKKKKKKK ${json}');
    json.forEach((e) => a.add(History.fromJson(e)));
    return a;
  }
}