import 'package:aggregator_mobile/components/dialogs/search_location.dart';
import 'package:flutter/material.dart';

class SelectLocationField extends StatelessWidget {
  final String title;
  final String value;
  final bool readOnly;
  final String error;
  final ValueChanged<String> onChange;
  final List<String> items;
  final bool noPadding;
  final bool noPaddingRight;
  final String dialogTitle;
  final String dialogSearchText;

  final bool noAlert;

  const SelectLocationField({
    Key key,
    this.title,
    this.value,
    this.readOnly = false,
    this.error,
    this.items,
    this.onChange,
    this.dialogTitle,
    this.dialogSearchText,
    this.noPaddingRight = false,
    this.noPadding = false,
    this.noAlert = false,
  }) : super(key: key);

  DropdownMenuItem<String> buildDropdownMenuItem(String value) =>
      DropdownMenuItem<String>(
          value: value,
          child: Text(value.replaceAll("", "\u{200B}"),
              maxLines: 1,
              softWrap: false,
              style: TextStyle(color: Colors.white)
          )
      );

  @override
  Widget build(BuildContext context) {
    var name = value == null ? '' : value ?? '';
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(left: noPadding ? 0 : 15, right: noPaddingRight ? 0 : 15, top: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 14, height: 20 / 14, color: Colors.grey)),
          GestureDetector(
            onTap: () async {
              if (readOnly) return;

              // if ((items == null || items.isEmpty) && key != Key('country')) {
              //   final body = t("alert_dialog_no_locations_body");
              //   final title = t('alert_dialog_no_locations_title');
              //   if (!noAlert) showAlertDialog(context, title, body);
              //   return;
              // }

              FocusManager.instance.primaryFocus.unfocus();
              final company = await showDialog(
                  context: context,
                  builder: (builderContext) => SearchLocationDialog(
                    items: items,
                  )
              );
              onChange(company);
            },
            child: Container(
                padding: EdgeInsets.only(top: 12, bottom: 4),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: this.readOnly
                        ? BorderSide.none
                        : BorderSide(
                      color: error == null ? Color(0xFFBDBDBD) : theme.errorColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!readOnly) Icon(Icons.search, color: Color(0xff808080)),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: readOnly ? 0 : 8.0),
                        child: Text(
                            name == '' ? 'warning_select_location' : name,
                            style: TextStyle(
                                color: name == '' ? Colors.grey : Colors.black,
                                fontSize: 16,
                                height: 24 / 16
                            )
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(error,
                  style: TextStyle(color: theme.errorColor, fontSize: 12.0)
              ),
            ),
        ],
      ),
    );
  }
}