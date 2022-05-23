import 'package:aggregator_mobile/api/itinerary_client.dart';
import 'package:aggregator_mobile/models/itinerary.dart';
import 'dart:async';
import 'bloc.dart';

class UiData {
  List<Itinerary> itineraryList = [];
  List<String> places = [];
  List<String> companies = [];
  ItineraryFilter filterData = ItineraryFilter();

  UiData({this.itineraryList, this.places, this.companies, this.filterData});
}

class ItineraryListUiState {
  UiState uiState;
  UiData uiData;
  ErrorType errorType;

  ItineraryListUiState(this.uiState, {this.uiData, this.errorType});

  factory ItineraryListUiState.normal(UiData uiData) =>
      ItineraryListUiState(UiState.normal, uiData: uiData);

  // factory ShipmentListUiState.error(ErrorType errorType) =>
  //     ShipmentListUiState(UiState.error, errorType: errorType);

  factory ItineraryListUiState.loading() => ItineraryListUiState(UiState.loading);
}

class ItineraryListBloc implements Bloc {
  final _controller = StreamController<ItineraryListUiState>();
  UiData _uiData;
  Stream<ItineraryListUiState> get stream => _controller.stream;
  List<Itinerary> _itineraries= [];

  var _offset = 0;
  var _total = 100;
  final _count = 30;

  bool refresh = false;
  bool checkCloseTimer = false;

  ItineraryClient _client = ItineraryClient();


  @override
  void dispose() {}


  void init() async {
    _controller.sink.add(ItineraryListUiState.loading());

    List<String> locations = await _client.fetchLocations();
    List<String> companies = await _client.fetchCompanies();
    _itineraries = await _client.fetchItineraries();

    _uiData = UiData(
        itineraryList: _itineraries,
        places: locations,
        companies: companies,
        filterData: ItineraryFilter()
    );


    _controller.sink.add(ItineraryListUiState.normal(_uiData));
  }

  Future query() async {
    if (_itineraries.isEmpty)
      _controller.sink.add(ItineraryListUiState.loading());

    List<String> companies = await _client.fetchCompanies();
    List<String> locations = await _client.fetchLocations();
    _itineraries = await _client.fetchItineraries();
    _uiData = UiData(
        itineraryList: _itineraries,
        places: locations,
        companies: companies,
        filterData: _uiData.filterData
    );

    _controller.sink.add(ItineraryListUiState.normal(_uiData));
  }

  clearFilters(){
    _uiData.filterData = ItineraryFilter();
  }

  bool canLoadMore() {
    return _offset < _total && _total > _count;
  }

  loadMore() async {
    if (!canLoadMore()) return;
    _offset += _count;

    await query();
  }

  reload() async {
    _offset = 0;
    _itineraries = [];
    await query();
  }

}

class ItineraryFilter {
  String from;
  String to;
  DateTime date;
  String company;


  ItineraryFilter({this.to, this.from, this.date, this.company});
}