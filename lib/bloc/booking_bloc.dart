import 'package:aggregator_mobile/api/booking_client.dart';
import 'package:aggregator_mobile/api/itinerary_client.dart';
import 'package:aggregator_mobile/models/bus.dart';
import 'dart:async';
import 'bloc.dart';

class UiData {
  Bus bus;

  UiData({this.bus});
}

class BookingUiState {
  UiState uiState;
  UiData uiData;
  ErrorType errorType;

  BookingUiState(this.uiState, {this.uiData, this.errorType});

  factory BookingUiState.normal(UiData uiData) =>
      BookingUiState(UiState.normal, uiData: uiData);

  // factory ShipmentListUiState.error(ErrorType errorType) =>
  //     ShipmentListUiState(UiState.error, errorType: errorType);

  factory BookingUiState.loading() => BookingUiState(UiState.loading);
}

class BookingBloc implements Bloc {
  final _controller = StreamController<BookingUiState>();
  UiData _uiData;
  Stream<BookingUiState> get stream => _controller.stream;
  Bus _bus;

  BookingClient _client = BookingClient();

  @override
  void dispose() {}


  void init(int id) async {
    _controller.sink.add(BookingUiState.loading());

    _bus = await _client.fetchBus(id);

    _uiData = UiData(
        bus: _bus,
    );

    _controller.sink.add(BookingUiState.normal(_uiData));
  }

  void selectPlace(int id, bool check){
    if (check)
      _bus.seats.where((e) => e.status == 'me').forEach((e) => e.status = 'vacant');
    _bus.seats.firstWhere((e) => e.id == id).status = check? 'me' : 'vacant';
    _controller.sink.add(BookingUiState.normal(_uiData));
  }

  void clear(){
    _bus.seats.where((e) => e.status == 'me').forEach((e) => e.status = 'vacant');
    _controller.sink.add(BookingUiState.normal(_uiData));

  }

  Future buyTicket(int tripId, int placeId) async {
    await _client.buyTicket(tripId, placeId);
  }

  // Future query() async {
  //   if (_itineraries.isEmpty)
  //     _controller.sink.add(BookingUiState.loading());
  //
  //   List<String> companies = await _client.fetchCompanies();
  //   List<String> locations = await _client.fetchLocations();
  //   _itineraries = await _client.fetchItineraries();
  //   _uiData = UiData(
  //       itineraryList: _itineraries,
  //       places: locations,
  //       companies: companies,
  //   );
  //
  //   _controller.sink.add(BookingUiState.normal(_uiData));
  // }

}
