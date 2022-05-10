import 'package:aggregator_mobile/api/booking_client.dart';
import 'package:aggregator_mobile/api/itinerary_client.dart';
import 'package:aggregator_mobile/models/bus.dart';
import 'package:aggregator_mobile/models/user.dart';
import 'dart:async';
import 'bloc.dart';

class UiData {
  Bus bus;
  List<Passenger> passengers = [];

  UiData({this.bus, this.passengers});
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
  List<Passenger> _passengers = [];

  BookingClient _client = BookingClient();

  @override
  void dispose() {}


  void init(int id, User user) async {
    _controller.sink.add(BookingUiState.loading());

    _bus = await _client.fetchBus(id);

    Passenger p = Passenger();
    p.me = true;
    p.name = user.name;
    p.surname = user.surname;
    p.lastname = user.lastname;
    _passengers.add(p);

    _uiData = UiData(
        bus: _bus,
        passengers: _passengers
    );

    _controller.sink.add(BookingUiState.normal(_uiData));
  }

  void selectPlace(int id, bool check){
    //if (check)
    //  _bus.seats.where((e) => e.status == 'me').forEach((e) => e.status = 'vacant');
    _bus.seats.firstWhere((e) => e.id == id).status = check? 'me' : 'vacant';
    _controller.sink.add(BookingUiState.normal(_uiData));
  }

  void changePassengers(List<Passenger> passengers){
    _uiData.passengers = passengers;
    _controller.sink.add(BookingUiState.normal(_uiData));
  }

  void clear(User user){
    _bus.seats.where((e) => e.status == 'me').forEach((e) => e.status = 'vacant');
    Passenger p = Passenger();
    p.me = true;
    p.name = user.name;
    p.surname = user.surname;
    p.lastname = user.lastname;
    //_passengers.add(p);
    _uiData.passengers = [p];
    _controller.sink.add(BookingUiState.normal(_uiData));

  }

  Future<bool> buyTicket(int tripId, List<Seat> seats, List<Passenger> passengers ) async {
    return await _client.buyTicket(tripId, seats, passengers);
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
