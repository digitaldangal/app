import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';


abstract class BaseFirebaseEntity {

  DataSnapshot _snapshot;

  final _values = <String, dynamic>{};

  BaseFirebaseEntity() : _snapshot = null;

  String get key => _snapshot?.key;

  int get timestamp => getValue('timestamp');

  Map<String, dynamic> get values => _snapshot?.value ?? _values;

  @mustCallSuper
  BaseFirebaseEntity.fromSnapshot(this._snapshot);

  dynamic getValue(String key) => values[key];

  void setValue(String key, dynamic value) => this.values[key] = value;

  @mustCallSuper
  Map<String, dynamic> toMap() {
    values['timestamp'] ??= ServerValue.timestamp;
    return values;
  }

  @override
  String toString() {
    return '$runtimeType {key: $key}';
  }

  void updateFromSnapshot(DataSnapshot snapshot) {
    this._snapshot = snapshot;
  }


}