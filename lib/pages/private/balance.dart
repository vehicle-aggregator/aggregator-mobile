import 'package:aggregator_mobile/api/auth.dart';
import 'package:aggregator_mobile/bloc/bloc.dart';
import 'package:aggregator_mobile/bloc/history_block.dart';
import 'package:aggregator_mobile/components/dialogs/change_balance_dialog.dart';
import 'package:aggregator_mobile/models/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BalanceScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BalanceState();
}

class BalanceState extends State<BalanceScreen>{
  AuthModel auth;
  HistoryListBloc _bloc;

  @override
  void initState() {
    _bloc = HistoryListBloc();
    _bloc.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthModel>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.refresh, color: Colors.white,),
          onPressed: () async {
            _bloc.refresh = true;
            await _bloc.reload();
          },
        ),
      appBar: AppBar(
          title: Container(
            child: Text('Баланс'),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.account_balance_wallet),
              onPressed: () => setState((){
                print('asdasd');
              }),
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white)
      ),
      body: StreamBuilder<HistoryListUiState>(
          stream: _bloc.stream,
          initialData: HistoryListUiState.loading(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5), borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ваш баланс:', style: TextStyle(fontSize: 16, color: Color(0xFF667689)),),
                              Container(
                                child: Row(
                                  children: [
                                    Text(auth.user.balance.toString(), style: TextStyle(fontSize: 24, color: Color(0xFF667689)),),
                                    Icon(CupertinoIcons.money_rubl, color: Color(0xFF667689))
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: 48,
                            child: OutlinedButton(
                                onPressed: () async {
                                  var result = await showDialog(
                                      context: context,
                                      builder: (builderContext) => ChangeBalanceDialog()
                                  );
                                  if (result){
                                    var instance = await SharedPreferences.getInstance();
                                    await this.auth.getUserProfile(instance.getInt('ID'));
                                    setState(() {});
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  side: BorderSide(color: Colors.green),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.add, color: Colors.white,),
                                    Text('Пополнить', style: TextStyle(color: Colors.white, fontSize: 18),)
                                  ],
                                )
                            ),
                          ),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text('Доступно 120 бонусов спасибо', style: TextStyle(color: Color(0xFF667689)),)
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('История оплат', style: TextStyle(color: Color(0xFF988AAC), fontSize: 24),),
                      IconButton(
                          onPressed: () => print(123),
                          icon: Icon(Icons.menu, color: Color(0xFF988AAC))
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: HistoryList(bloc: _bloc, snapshot: snapshot),
                )

              ],
            );
          }
      )
    );
  }
}

class HistoryList extends StatefulWidget{
  final snapshot;
  final HistoryListBloc _bloc;

  const HistoryList({
    Key key,
    @required HistoryListBloc bloc,
    @required this.snapshot,
  })  : _bloc = bloc, super(key: key);

  @override
  State<StatefulWidget> createState() => HistoryListState();
}

class HistoryListState extends State<HistoryList>{
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

    final HistoryListUiState state = widget.snapshot.data;
    List<History> historyList = state.uiData?.historyList ?? [];

    if (state.uiState == UiState.loading){
      return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
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
          itemCount: //widget._bloc.canLoadMore() ? itineraries.length + 1 :
          historyList.length + 1,
          itemBuilder: (context, index) {
            if (index >= historyList.length)
              return Container(
                height: 75,
              );
            final item = historyList[index];
            return HistoryItem(key: Key(index.toString()), item: item);
          },
        )
    );
  }

}

class HistoryItem extends StatelessWidget{
  final History item;

  const HistoryItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFF5F5F5), borderRadius: BorderRadius.all(Radius.circular(15))),
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
                        Text(
                          item.trip.from,
                          style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
                        Text(
                          getTime(item.trip.start),
                          style: TextStyle(color: Color(0xFFB4B9BF)),
                        )
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
                          Text(
                            item.trip.to,
                            style: TextStyle(color: Color(0xFF667689), fontSize: 18),),
                          Text(
                            getTime(item.trip.finish),
                            style: TextStyle(color: Color(0xFFB4B9BF)),
                          )
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
                                  Text(
                                    DateFormat("dd-MM-yyyy").format(item.trip.date),
                                    style: TextStyle(color: Color(0xFFB4B9BF)),),
                                ],
                              ),
                            ),
                            Container(

                                width: 90,
                                child: Row(
                                  children: [
                                    Icon(Icons.timelapse, color: Color(0xFFB4B9BF),),
                                    Text(
                                      getDuration(item.trip.start.difference(item.trip.finish).inMinutes.abs()),
                                      style: TextStyle(color: Color(0xFFB4B9BF)),
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.green
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, color: Colors.white),
                              Text('Завершено', style: TextStyle(color: Colors.white))
                            ]
                        ),
                      ),
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
                          Icon(CupertinoIcons.money_rubl, color: Color(0xFF667689), size: 32,),
                          Text(
                            (item.trip.price * ((item.passengers?.length ?? 0) + 1)).toString(),
                            style: TextStyle(color: Color(0xFF667689), fontSize: 26),)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //Text('+ 135', style: TextStyle(color:Color(0xFFB4B9BF))),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xFFB4B9BF)
                            ),
                              onPressed: () => print(678),
                              child: Icon(Icons.menu,color: Colors.white,)
                          )
                        ]
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

  String getTime(DateTime date){
    return (DateFormat('HH:mm').format(date));
  }

  String getDuration(int minutes){
    return '${minutes ~/ 60} ч ${minutes % 60} м';
  }

}