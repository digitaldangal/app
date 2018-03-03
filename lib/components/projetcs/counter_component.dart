import 'dart:async';

import 'package:crochet_land/model/project.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

String formatDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String durationInHours = duration.inHours == 0 ? '' : duration.inHours.toString() + ':';
  String twoDigitMinutes = duration.inMinutes == 0 ? '' : twoDigits(duration.inMinutes.remainder(Duration.MINUTES_PER_HOUR)) + ':';
  String twoDigitSeconds = duration.inSeconds == 0 ? '' : twoDigits(duration.inSeconds.remainder(Duration.SECONDS_PER_MINUTE));

  return "$durationInHours$twoDigitMinutes$twoDigitSeconds";
}

class _CounterComponentState extends State<CounterComponent> {
  Project _project;
  bool timeRunning = false;
  Timer _timer;

  _CounterComponentState(this._project);

  _tickTime(timer) {
    setState(() {
      this._project.timeSpent++;
    });
  }

  _resumeTimer() {
    _timer = new Timer.periodic(const Duration(seconds: 1), _tickTime);
  }

  _pauseTimer() {
    if (_timer != null) {
      this._timer.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pauseTimer();
  }

  @override
  Widget build(BuildContext context) {
    var duration = new Duration(seconds: _project.timeSpent);
    final theme = Theme.of(context).textTheme.display3;
    return new Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
      new Column(
        children: <Widget>[
          new Text(formatDuration(duration), style: theme),
          new RaisedButton(
            color: Theme.of(context).accentColor,
            onPressed: () {
              print('tap iniciar/pausar');
              if (timeRunning) {
                _pauseTimer();
              } else {
                _resumeTimer();
              }
              setState(() {
                timeRunning = !timeRunning;
              });
            },
            child: new Text(timeRunning ? 'Pausar' : 'Iniciar'),
          )
        ],
      ),
      new Column(
        children: <Widget>[
          new Text(
            _project.counter.toString(),
            style: theme,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new GestureDetector(
                onLongPress: () {
                  print('longPress -1');
                  setState(() {
                    _project.counter = 0;
                  });
                },
                child: new RaisedButton(
                  color: Theme.of(context).accentColor,
                  onPressed: _project.counter > 0
                      ? () {
                          print('tap -1');
                          setState(() {
                            _project.counter--;
                          });
                        }
                      : null,
                  child: new Text('-1'),
                ),
              ),
              new RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: () {
                  print('tap +1');
                  setState(() {
                    _project.counter++;
                  });
                },
                child: new Text('+1'),
              ),
            ],
          )
        ],
      ),
    ]);
  }
}

@immutable
class CounterComponent extends StatefulWidget {
  Project _project;

  CounterComponent(this._project);

  @override
  State<StatefulWidget> createState() {
    return new _CounterComponentState(this._project);
  }
}