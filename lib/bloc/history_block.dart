import 'package:aggregator_mobile/api/history_client.dart';
import 'package:aggregator_mobile/api/itinerary_client.dart';
import 'package:aggregator_mobile/models/history.dart';
import 'package:aggregator_mobile/models/itinerary.dart';
import 'dart:async';
import 'bloc.dart';

class UiData {
  List<History> historyList = [];

  UiData({this.historyList});
}

class HistoryListUiState {
  UiState uiState;
  UiData uiData;
  ErrorType errorType;

  HistoryListUiState(this.uiState, {this.uiData, this.errorType});

  factory HistoryListUiState.normal(UiData uiData) =>
      HistoryListUiState(UiState.normal, uiData: uiData);

  // factory ShipmentListUiState.error(ErrorType errorType) =>
  //     ShipmentListUiState(UiState.error, errorType: errorType);

  factory HistoryListUiState.loading() => HistoryListUiState(UiState.loading);
}

class HistoryListBloc implements Bloc {
  final _controller = StreamController<HistoryListUiState>();
  UiData _uiData;
  Stream<HistoryListUiState> get stream => _controller.stream;
  List<History> _historyList= [];

  bool refresh = false;
  bool checkCloseTimer = false;

  HistoryClient _client = HistoryClient();


  @override
  void dispose() {}


  void init() async {
    _controller.sink.add(HistoryListUiState.loading());

    _historyList = await _client.fetchHistory();

    _uiData = UiData(
      historyList: _historyList
    );


    _controller.sink.add(HistoryListUiState.normal(_uiData));
  }

  reload() async {
    _historyList = [];
    init();
  }

  // Future query() async {
  //   if (_historyList.isEmpty)
  //     _controller.sink.add(ItineraryListUiState.loading());
  //
  //   _itineraries = await _client.fetchItineraries();
  //   _uiData = UiData(
  //       itineraryList: _itineraries,
  //       places: locations,
  //       companies: companies,
  //       filterData: _uiData.filterData
  //   );
  //
  //   _controller.sink.add(ItineraryListUiState.normal(_uiData));
  // }


}
