import 'package:aggregator_mobile/components/dialogs/choose_passenger.dart';
import 'package:aggregator_mobile/models/user.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RowWithItems extends StatefulWidget {
  List<Passenger> items;
  List<Passenger> chooseFrom;
  final Function(List<Passenger>) onChange;
  final bool plus;


  RowWithItems({
    Key key,
    @required this.items,
    @required this.chooseFrom,
    @required this.onChange,
    this.plus
  }) : super(key: key);

  @override
  _RowWithItemsState createState() => _RowWithItemsState();
}

class _RowWithItemsState extends State<RowWithItems> {
  final ScrollController _scrollController = ScrollController();

  onClick(BuildContext context) async {
    Passenger newPassenger = await showDialog(
      context: context,
      builder: (builderContext) => ChoosePassengerDialog(
        items: widget.chooseFrom,
      ),
      // builder: (builderContext) => AddItemForListDialog(
      //     title: widget.title,
      //     description: widget.description,
      //     defItems: widget.defItems,
      //     previousIdsList: widget.items,
      //     addCode: (value) {
      //       print('value $value');
      //       if (!widget.items.contains(value)) {
      //         widget.onChange([...widget.items, value]);
      //       }
      //     },
      //     addCodes: (values){
      //       List<String> listToAdd = [];
      //       values.forEach((v) {
      //         if (!widget.items.contains(v))
      //           listToAdd.add(v);
      //       });
      //       widget.onChange([...widget.items, ...listToAdd]);
      //     }
      // ),

    );
    widget.onChange([...widget.items, newPassenger]);
  }

  Widget build(BuildContext context) {
    //if (widget.needToScrollRight == true)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut
        );
      });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Пассажиры',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 16,
                color: Color(0xFF667689)
            ),
          ),
          Container(
            height: 48,
            child: GestureDetector(
              onTap: widget.plus ? () => onClick(context) : null,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(width: 1, color: Color(0xFF7952B3)),
                      ),
                      child: ListView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                for (var i = 0; i < widget.items.length; i++)
                                  Container(
                                    height: 40,
                                    margin: EdgeInsets.only(right: i != widget.items.length - 1 ? 4 : 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Color(0xFF7952B3),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 8),
                                        Text(
                                          "${widget.items[i].surname} ${widget.items[i].name.substring(0,1)}.${widget.items[i].lastname.substring(0,1)}.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        //if (widget.items[i].me != true) SizedBox(width: 8),
                                        if (widget.items[i].me != true)
                                          IconButton(
                                            padding: EdgeInsets.all(0),
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              List<Passenger> temp = [...widget.items];
                                              temp.remove(widget.items[i]);
                                              widget.onChange(temp);
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (widget.plus)
                    Container(
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () => onClick(context),
                        icon: Icon(Icons.add, color: Color(0xFF7952B3)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}