import 'package:flutter/material.dart';

nullWidget() {
  return Container(
    height: 0,
    width: 0,
  );
}

_buildButtonsAlert(bool ok, String textButtonOk, BuildContext context) {
  return Column(
    children: <Widget>[
      FlatButton(
          shape: Border.all(color: Colors.transparent),
          child: Text(
            textButtonOk.isEmpty ? 'Sim' : textButtonOk,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          }),
      ok ? nullWidget() : Divider(),
      ok
          ? nullWidget()
          : FlatButton(
              shape: Border.all(color: Colors.transparent),
              child: Text(
                'Não',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              })
    ],
  );
}

alertDialogPadrao(BuildContext context, String title, String labelMenssagem,
    Color backgroundColor,
    {bool ok = false, IconData icone, String textButtonOk = ""}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Center(
            child: Column(children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Icon(
                    icone ?? Icons.help_outline,
                    size: 40.0,
                    color: Colors.white,
                  )),
              Center(
                  child: Text(
                title,
                style: TextStyle(color: Colors.white),
              )),
            ]),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                  labelMenssagem,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Divider(
                color: Colors.transparent,
              ),
              _buildButtonsAlert(ok, textButtonOk, context)
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        );
      });
}
