import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchLocationDialog extends StatefulWidget {
  final List<String> items;
  final String dialogTitle;
  final String dialogSearchText;
  final bool showAddress;

  const SearchLocationDialog({
    Key key,
    this.items,
    this.dialogTitle,
    this.dialogSearchText,
    this.showAddress = true,
  }) : super(key: key);

  @override
  _SearchLocationDialogState createState() => _SearchLocationDialogState();
}

class _SearchLocationDialogState extends State<SearchLocationDialog>
    with SingleTickerProviderStateMixin {
  String _value;

  AnimationController controller;
  Animation<Offset> offsetAnimation;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ));

//    controller.addListener(() => setState(() {}));
    controller.forward();

    _value = '';
  }

  @override
  Widget build(BuildContext context) {
    var _items = widget.items;
    if (_value.isNotEmpty) {
      _items = _items
          .where(
            (c) => c.contains(
          RegExp(RegExp.escape(_value), caseSensitive: false),
        ),
      )
          .toList();
    }

    return SlideTransition(
      position: offsetAnimation,
      child: Dialog(
          insetPadding: EdgeInsets.only(top: 70),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Container(
            height: MediaQuery.of(context).size.height - 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                      Icon(Icons.arrow_back, size: 24, color: Colors.black),
                    )),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Выбирете локацию'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 0),
                      child: Text(
                          widget.dialogSearchText ?? "Поиск",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 14, height: 20 / 14)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 0),
                      child: TextFormField(
                        autocorrect: false,
                        autofocus: false,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never),
                        onChanged: (value) => setState(() => _value = value),
                        style: TextStyle(
                          fontSize: 16,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(height: 1, thickness: 1),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _items
                          .map((item) => ListItem(
                          showAddress: widget.showAddress,
                          key: UniqueKey(),
                          item: item,
                          onTap: (location) =>
                              Navigator.of(context).pop(location)))
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class ListItem extends StatelessWidget {
  final bool showAddress;
  final String item;
  final onTap;

  const ListItem({
    this.item,
    Key key,
    this.onTap,
    this.showAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(item),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 16),
              child: Text(
                item,
                style: TextStyle(
                    color: Color(0xff1f1f1f),
                    fontSize: 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (showAddress) SizedBox(height: 8),
            // if (showAddress)
            //   Padding(
            //     padding: EdgeInsets.only(left: 15, right: 15),
            //     child: Builder(
            //       builder: (BuildContext context) {
            //         String country = item.country;
            //         if (int.tryParse(country) != null) {
            //           country = translate('COUNTRY.${item.country}');
            //         }
            //         if (country == null) country = '';
            //         return RichText(
            //           text: TextSpan(
            //             children: [
            //               TextSpan(
            //                 text: '${item.city}',
            //                 style: TextStyle(
            //                   color: Color(0xff808080),
            //                   fontSize: 16,
            //                   height: 24 / 16,
            //                   fontWeight: FontWeight.normal,
            //                 ),
            //               ),
            //               if (country != '')
            //                 TextSpan(
            //                   text: ', $country',
            //                   style: TextStyle(
            //                     color: Color(0xff808080),
            //                     fontSize: 16,
            //                     height: 24 / 16,
            //                     fontWeight: FontWeight.normal,
            //                   ),
            //                 ),
            //             ],
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            SizedBox(height: 16),
            Divider(
              height: 1,
              thickness: 1,
            ),
          ]),
    );
  }
}