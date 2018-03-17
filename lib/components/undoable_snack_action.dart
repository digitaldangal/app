import 'dart:async';

import 'package:flutter/material.dart';

const undoableDuration = const Duration(seconds: 3);

Function showUndoableAction = (context, String text, Function action) {
  var canceled = false;

  new Future.delayed(new Duration(seconds: undoableDuration.inSeconds + 1), () {
    if (!canceled) {
      action();
    }
  });
  Scaffold.of(context).showSnackBar(new SnackBar(
        duration: undoableDuration,
        content: new Text(text),
        action: new SnackBarAction(label: 'Desfazer', onPressed: () => canceled = true),
      ));
};
