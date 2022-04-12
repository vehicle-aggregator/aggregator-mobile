import 'package:aggregator_mobile/bloc/bloc.dart';
import 'package:aggregator_mobile/bloc/itinerary_list_bloc.dart';
import 'package:aggregator_mobile/components/dialogs/search_location.dart';
import 'package:aggregator_mobile/models/itinerary.dart';
import 'package:aggregator_mobile/widgets/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItineraryListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ItineraryListScreenState();
}

class ItineraryListScreenState extends State<ItineraryListScreen>{
  ItineraryListBloc _bloc;
  bool isFiltersOn = false;
  DateTime date;
  String to;
  String from;

  @override
  void initState() {
    _bloc = ItineraryListBloc();
    _bloc.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Маршруты'),
        actions: [
            IconButton(
              icon: isFiltersOn ? Icon(Icons.clear) : Icon(Icons.search),
              onPressed: () => setState((){
                isFiltersOn = !isFiltersOn;
              }),
            ),
        ],
      ),
      body: StreamBuilder<ItineraryListUiState>(
        stream: _bloc.stream,
        initialData: ItineraryListUiState.loading(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Column(
            children: [
              if (isFiltersOn)
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus.unfocus();
                                  final location = await showDialog(
                                      context: context,
                                      builder: (builderContext) => SearchLocationDialog(
                                    items: ['Владимир', 'Москва', 'Санкт-Петербург'],)
                                  );
                                  setState(() {
                                    from = location;
                                  });
                                },
                                child: Container(
                                  height: 48,
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  alignment: Alignment.centerLeft,
                                  child: Text(from == null ? 'Откуда': from,
                                      style: TextStyle(
                                          color: from == null ? Color(0xFFDCDCDC) : Color(0xFF667689),
                                          fontSize: 16
                                      )
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFFEDEBF0), width: 1),
                                    borderRadius: BorderRadius.circular(40)
                                  ),
                                ),
                              )
                            ),
                            IconButton(
                                  icon: Icon(Icons.repeat, color: Color(0xFF667689)),
                                onPressed: () {
                                    String temp = to;
                                    to = from;
                                    from = temp;
                                    setState(() {});
                                },
                              ),
                            Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus.unfocus();
                                    final location = await showDialog(
                                        context: context,
                                        builder: (builderContext) => SearchLocationDialog(
                                          items: ['Владимир', 'Москва', 'Санкт-Петербург'],
                                        )
                                    );
                                    setState(() => to = location);
                                  },
                                  child: Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 15, right: 15),
                                    alignment: Alignment.centerLeft,
                                    child: Text(to == null ? 'Куда': to,
                                        style: TextStyle(
                                            color: to == null ? Color(0xFFDCDCDC) : Color(0xFF667689),
                                            fontSize: 16
                                        )
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFFEDEBF0), width: 1),
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: Row(
                          children:[
                            Expanded(
                              child: CustomDatePicker(
                                value: date,
                                hint: "Дата",
                                onChange: (value) => setState((){
                                  date = value;
                                }),
                              ),
                            ),
                             SizedBox(width: 48,),
                            Expanded(
                                child:OutlinedButton(
                                  onPressed: () => print(123),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search, color: Colors.white,),
                                      SizedBox(width: 10,),
                                      Text('Поиск', style: TextStyle(color: Colors.white, fontSize: 18),),
                                    ],
                                  ),

                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size(25, 48),
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                      backgroundColor: Color(0xFF988AAC)
                                  ),
                                )
                            )
                          ]
                        ),
                      ),
                      Divider(color:Color(0xFFEDEBF0), thickness: 2,)
                    ],
                  ),
                ),
                //ItineraryListFilter(),
              Expanded(
                child: ItineraryList(bloc: _bloc, snapshot: snapshot),
              )

            ],
          );

        },
      ),
    );
  }
}

class ItineraryList extends StatefulWidget{
  final snapshot;
  final ItineraryListBloc _bloc;

  const ItineraryList({
    Key key,
    @required ItineraryListBloc bloc,
    @required this.snapshot,
  })  : _bloc = bloc, super(key: key);

  @override
  State<StatefulWidget> createState() => ItineraryListState();
}

class ItineraryListState extends State<ItineraryList>{
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_isBottom)
      return;
    print('ON SCROLL');
    widget._bloc.loadMore();
  }

  bool get _isBottom {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.95);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    final ItineraryListUiState state = widget.snapshot.data;
    List<Itinerary> itineraries = state.uiData?.itineraryList ?? [];

    if (state.uiState == UiState.loading){
      print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
      return Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
        onRefresh: () async {
          print('REFRESH');
          //await widget._bloc.updateUserData(context);
          widget._bloc.refresh = true;
          await widget._bloc.reload();
        },
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: widget._bloc.canLoadMore() ? itineraries.length + 1 : itineraries.length,
          itemBuilder: (context, index) {
            if (index >= itineraries.length)
              return Container(
                alignment: Alignment.center,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(40),
                    width: 33,
                    height: 33,
                    child: CircularProgressIndicator(strokeWidth: 1.5, color: Theme.of(context).primaryColor),
                  ),
                ),
              );
            final item = itineraries[index];
            return ItineraryItem(key: Key(index.toString()), item: item);
          },
        )
    );
  }

}

class ItineraryItem extends StatelessWidget{
  final Itinerary item;

  const ItineraryItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xFFF5F5F5), borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        margin: EdgeInsets.only(left: 15, right: 15, top:15),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex:5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.from, style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
                              Text(getTime(item.departureTime), style: TextStyle(color: Color(0xFFB4B9BF)),)
                            ],
                          ),
                          Icon(Icons.arrow_forward_rounded, color: Color(0xFFB4B9BF),),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.to, style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
                              Text(getTime(item.arrivalTime), style: TextStyle(color: Color(0xFFB4B9BF)),)
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                        child: Wrap(
                          direction: Axis.horizontal,
                          //crossAxisAlignment: WrapCrossAlignment.start,
                          //alignment: WrapAlignment.start,
                          children: [
                            Container(
                              width: 110,
                              child: Row(
                                children: [
                                  Icon(Icons.today_outlined, color: Color(0xFFB4B9BF)),
                                  Text(DateFormat("dd-MM-yyyy").format(item.date), style: TextStyle(color: Color(0xFFB4B9BF)),),
                                ],
                              ),
                            ),
                            Container(
                                width: 90,
                              child: Row(
                                children: [
                                  Icon(Icons.timelapse, color: Color(0xFFB4B9BF),),
                                  Text(
                                    item.arrivalTime > item.departureTime
                                        ? getDuration(item.arrivalTime - item.departureTime)
                                        : getDuration(86400000 - item.departureTime + item.arrivalTime),
                                    style: TextStyle(color: Color(0xFFB4B9BF)),
                                  )
                                ],
                              )
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('от ', style: TextStyle(color: Color(0xFFB4B9BF), fontSize: 16),),
                          Text(item.price.toString() + ' Р', style: TextStyle(color: Color(0xFF667689), fontSize: 20),)
                        ],
                      ),
                      Container(
                        child: OutlinedButton(
                          onPressed: () => print(123),
                          child: Text('КУПИТЬ', style: TextStyle(color: Colors.white, fontSize: 18),),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.green
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              child: Text('${item.transporter}, Свободных мест ${item.vacantQuantity}', style: TextStyle(color: Color(0xFFB4B9BF)),)
            )

          ],
        )
    );
  }

  String getTime(int ms){
    DateTime d = DateTime(1, 1, 1, ms ~/ 1000 ~/ 60 ~/ 60, ms ~/ 1000 ~/ 60 % 60);
    return (DateFormat('HH:mm').format(d));
  }

  String getDuration(int ms){
    DateTime d = DateTime(1, 1, 1, ms ~/ 1000 ~/ 60 ~/ 60, ms ~/ 1000 ~/ 60 % 60);
    return '${d.hour} ч ${d.minute} м';
  }
}