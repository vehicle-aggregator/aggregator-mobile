import 'package:aggregator_mobile/models/history.dart';
import 'package:aggregator_mobile/network/endpoints.dart';
import 'package:aggregator_mobile/network/rest_client.dart';

class HistoryClient{
  RestClient _client = RestClient();

  Future<List<History>> fetchHistory() async {
    dynamic json = await _client.get(Endpoints.history);
    List<History> a = [];
    json.forEach((e) => a.add(History.fromJson(e)));
    return a;
  }

  Future<bool> addFeedback(dynamic model) async {
    dynamic json = await _client.postRaw(Endpoints.feedback, model);
    return json['ID'].toString() == null;
  }
}