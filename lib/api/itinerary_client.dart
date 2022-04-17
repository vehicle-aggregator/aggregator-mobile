import 'package:aggregator_mobile/models/itinerary.dart';
import 'package:aggregator_mobile/network/endpoints.dart';
import 'package:aggregator_mobile/network/rest_client.dart';

class ItineraryClient {
  RestClient _client = RestClient();


  fetchLocations() async {
    dynamic json = await _client.get(Endpoints.places);
    List<String> places = [];
    json.forEach((e) => places.add(e['Name']));
    return places;
  }

  fetchCompanies() async {
    dynamic json = await _client.get(Endpoints.companies);
    List<String> companies = [];
    json.forEach((e) => companies.add(e['name']));
    return companies;
  }


  fetchItineraries() async {
    dynamic json = await _client.get(Endpoints.routes);
    var a = json.map((e) => Itinerary.fromJson(e));
  }
}