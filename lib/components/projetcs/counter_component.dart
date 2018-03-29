import 'dart:async';

import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/stores/project_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:service_registry/service_registry.dart';

String formatDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String durationInHours = duration.inHours == 0 ? '' : duration.inHours.toString() + ':';
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(Duration.MINUTES_PER_HOUR)) + ':';
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(Duration.SECONDS_PER_MINUTE));

  return "$durationInHours$twoDigitMinutes$twoDigitSeconds";
}

class CounterComponentState extends State<CounterComponent> with TickerProviderStateMixin {
  Project _project;

  CounterComponentState(this._project);

  StreamSubscription _projectStoreSubscription;

  @override
  void initState() {
    _projectStoreSubscription =
        ServiceRegistry.getService<ProjectStore>(ProjectStore).listen((store) {
          this.setState(() {});
    });
    super.initState();
  }

  _resumeTimer() {
    ProjectStore.startTimerAction(_project);
  }

  _pauseTimer() {
    ProjectStore.stopTimerAction(_project);
  }

  @override
  void dispose() {
    _projectStoreSubscription.cancel();
    super.dispose();
  }

  _buildTimePassedDialog() {
    final initialDuration = new Duration(seconds: _project.timeSpent);

    int hours = initialDuration.inHours;
    int minutes = (initialDuration.inMinutes - (hours * 60)).floor();

    final hoursScrollController = new FixedExtentScrollController(initialItem: hours);
    final minutesScrollController = new FixedExtentScrollController(initialItem: minutes);

    return new Row(
      children: <Widget>[
        new Expanded(
            child: new CupertinoPicker(
                backgroundColor: Colors.white,
                scrollController: hoursScrollController,
                itemExtent: 48.0,
                onSelectedItemChanged: (newHours) {
                  hours = newHours;
                  _project.timeSpent = new Duration(hours: newHours, minutes: minutes).inSeconds;
                  debugPrint('Time spent: ${_project.timeSpent}');
                },
                children: new List<Widget>.generate(
                    100, (index) => new Center(child: new Text('$index h'))))),
        new Expanded(
            child: new CupertinoPicker(
                backgroundColor: Colors.white,
                scrollController: minutesScrollController,
                itemExtent: 48.0,
                onSelectedItemChanged: (newMinutes) {
                  minutes = newMinutes;
                  _project.timeSpent = new Duration(hours: hours, minutes: newMinutes).inSeconds;
                  debugPrint('Time spent: ${_project.timeSpent}');
                },
                children: new List<Widget>.generate(
                    60, (index) => new Center(child: new Text('$index m'))))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var duration = new Duration(seconds: _project.timeSpent);
    final theme = Theme
        .of(context)
        .textTheme
        .display3;
    return new Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
      new Column(
        children: <Widget>[
          new GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context, builder: (context) => _buildTimePassedDialog());
//                showDialog(context: context, child: _buildTimePassedDialog());
              },
              child: new Text(formatDuration(duration), style: theme, key: new Key('counter'))),
          new RaisedButton(
            color: Theme
                .of(context)
                .accentColor,
            onPressed: () {
              print('tap iniciar/pausar');
              if (widget.store.isCountingTime(_project)) {
                _pauseTimer();
              } else {
                _resumeTimer();
              }
            },
            child: new Text(widget.store.isCountingTime(_project) ? 'Pausar' : 'Iniciar'),
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
                  ProjectStore.resetCounterAction(_project);
                },
                child: new RaisedButton(
                  color: Theme
                      .of(context)
                      .accentColor,
                  onPressed: _project.counter > 0
                      ? () {
                    print('tap -1');
                    ProjectStore.decreaseCounterAction(_project);
                  }
                      : null,
                  child: new Text('-1'),
                ),
              ),
              new RaisedButton(
                color: Theme
                    .of(context)
                    .accentColor,
                onPressed: () {
                  print('tap +1');
                  ProjectStore.increaseCounterAction(_project);
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

class CounterComponent extends StatefulWidget {
  final Project _project;
  final ProjectStore store = ServiceRegistry.getService<ProjectStore>(ProjectStore);

  CounterComponent(this._project);

  @override
  State<StatefulWidget> createState() {
    return new CounterComponentState(this._project);
  }
}
