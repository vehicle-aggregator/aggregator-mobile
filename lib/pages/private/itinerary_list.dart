import 'package:aggregator_mobile/bloc/bloc.dart';
import 'package:aggregator_mobile/bloc/itinerary_list_bloc.dart';
import 'package:aggregator_mobile/components/dialogs/search_location.dart';
import 'package:aggregator_mobile/helpers/date_time_helper.dart';
import 'package:aggregator_mobile/models/itinerary.dart';
import 'package:aggregator_mobile/widgets/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'booking.dart';

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.refresh, color: Colors.white,),
        onPressed: () async {
          _bloc.refresh = true;
          await _bloc.reload();
        },
      ),
      appBar: AppBar(
        title: Text('Маршруты'),
        actions: [
          IconButton(
            icon: isFiltersOn ? Icon(Icons.clear) : Icon(Icons.search),
            onPressed: () => setState((){
              _bloc.clearFilters();
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
                                            items: snapshot.data.uiData.places
                                        )
                                    );
                                    setState(() {
                                      from = location;
                                      snapshot.data.uiData.filterData.from = location;
                                    });
                                  },
                                  child: Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 15, right: 15),
                                    alignment: Alignment.centerLeft,
                                    child: Text(snapshot.data.uiData?.filterData?.from == null ? 'Откуда': snapshot.data.uiData.filterData.from,
                                        style: TextStyle(
                                            color: snapshot.data.uiData?.filterData?.from == null ? Color(0xFFDCDCDC) : Color(0xFF667689),
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
                                snapshot.data.uiData.filterData.from = from;
                                snapshot.data.uiData.filterData.to = to;
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
                                            items: snapshot.data.uiData.places
                                        )
                                    );
                                    setState(() {
                                      to = location;
                                      snapshot.data.uiData.filterData.to = location;
                                    });
                                  },
                                  child: Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 15, right: 15),
                                    alignment: Alignment.centerLeft,
                                    child: Text(snapshot.data.uiData?.filterData?.to == null ? 'Куда': snapshot.data.uiData.filterData.to,
                                        style: TextStyle(
                                            color: snapshot.data.uiData?.filterData?.to == null ? Color(0xFFDCDCDC) : Color(0xFF667689),
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
                                flex:1,
                                child: CustomDatePicker(
                                    value: snapshot.data.uiData?.filterData?.date,
                                    hint: "Дата",
                                    onChange: (value) {
                                      setState((){
                                        date = value;
                                        snapshot.data.uiData.filterData.date = date;
                                      });
                                    }
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () async {
                                      FocusManager.instance.primaryFocus.unfocus();
                                      final company = await showDialog(
                                          context: context,
                                          builder: (builderContext) => SearchLocationDialog(
                                              items: snapshot.data.uiData.companies
                                          )
                                      );
                                      setState(() {
                                        snapshot.data.uiData.filterData.company = company;
                                      });
                                    },
                                    child: Container(
                                      height: 48,
                                      padding: EdgeInsets.only(left: 15, right: 15),
                                      alignment: Alignment.centerLeft,
                                      child: Text(snapshot.data.uiData?.filterData?.company == null ? 'Компания': snapshot.data.uiData.filterData.company,
                                          style: TextStyle(
                                              color: snapshot.data.uiData?.filterData?.company == null ? Color(0xFFDCDCDC) : Color(0xFF667689),
                                              fontSize: 16
                                          )
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Color(0xFFEDEBF0), width: 1),
                                          borderRadius: BorderRadius.circular(40)
                                      ),
                                    ),
                                  )
                              )
                            ]
                        ),
                      ),
                      //Text('${snapshot.data.uiData?.filterData?.costStart ?? 'sss'} --- ${snapshot.data.uiData?.filterData?.costEnd ?? 'sss'} --- ${snapshot.data.uiData?.filterData?.to ?? 'sss'}'),
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
    //widget._bloc.loadMore();
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
      return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
    }

    itineraries = itineraries.where((element) =>
    (state.uiData.filterData?.from == null || state.uiData.filterData.from == element.from) &&
        (state.uiData.filterData?.to == null || state.uiData.filterData.to == element.to) &&
        (state.uiData.filterData?.date == null || (state.uiData.filterData.date.day == element.date.day && state.uiData.filterData.date.month == element.date.month && state.uiData.filterData.date.year == element.date.year)) &&
        (state.uiData.filterData?.company == null || element.transporter.contains(state.uiData.filterData.company))
    ).toList();

    return RefreshIndicator(
        onRefresh: () async {
          //await widget._bloc.updateUserData(context);
          widget._bloc.refresh = true;
          await widget._bloc.reload();
        },
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: //widget._bloc.canLoadMore() ? itineraries.length + 1 :
          itineraries.length + 1,
          itemBuilder: (context, index) {
            if (index >= itineraries.length)
              return Container(
                height: 75,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child:Container(
                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.from, style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
                        Text(DateTimeHelper.getTime(item.start), style: TextStyle(color: Color(0xFFB4B9BF)),)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      child: Icon(Icons.arrow_forward_rounded, color: Color(0xFFB4B9BF),)),
                ),

                Expanded(
                    flex: 5,
                    child: Container(
                      //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(item.to, style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
                          Text(DateTimeHelper.getTime(item.finish), style: TextStyle(color: Color(0xFFB4B9BF)),)
                        ],
                      ),
                    )
                )

              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Flexible(
                  flex:5,
                  child: Column(
                    children: [
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
                                      DateTimeHelper.getDuration(item.start.difference(item.finish).inMinutes.abs()),
                                      style: TextStyle(color: Color(0xFFB4B9BF)),
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                      Row(
                          children: [
                            Icon(Icons.business_center, color: Color(0xFFB4B9BF)),
                            Text('${item.transporter}', style: TextStyle(color: Color(0xFFB4B9BF)))
                          ]
                      ),
                      Row(
                          children: [
                            Icon(Icons.people_alt_outlined, color: Color(0xFFB4B9BF),),
                            Text('Свободных мест ${item.vacantQuantity}', style: TextStyle(color: Color(0xFFB4B9BF)))
                          ]
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
                          Icon(CupertinoIcons.money_rubl, color: Color(0xFFB4B9BF)),
                          Text(item.price.toString(), style: TextStyle(color: Color(0xFF667689), fontSize: 20),)
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () => pushNewScreen(
                            context,
                            screen: BookingScreen(item),
                            withNavBar: false,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          ),
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

          ],
        )
    );
  }

}