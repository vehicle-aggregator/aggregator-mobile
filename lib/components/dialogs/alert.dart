import 'package:flutter/material.dart';

defaultFunction() async {}

Future<void> showAlertDialog(context, title, body,
    [onPressed = defaultFunction]) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () async {
              Navigator.of(context).pop();
              await onPressed();
            },
          ),
        ],
      );
    },
  );
}

Future<dynamic> showAlertDialogWithTwoButtons({
  @required BuildContext context,
  @required String title,
  String body = '',
  String cancelBtnText = 'Отмена',
  String acceptBtnText = 'Ок',
  bool barrierDismissible = true,
}) async {

  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                  CloseButton(),
                ],
              ),
            ),
            Divider(height: 1),
            if (body != null)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(body),
              ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom().copyWith(
                      side: MaterialStateProperty.resolveWith<BorderSide>(
                            (Set<MaterialState> states) {
                          return BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          );
                        },
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      cancelBtnText,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context,true);
                    },
                    child: Text(
                      acceptBtnText,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}