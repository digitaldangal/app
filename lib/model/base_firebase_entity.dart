import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class BaseFirebaseEntity {
  DocumentSnapshot doc;

  final _values = <String, dynamic>{};

  BaseFirebaseEntity() : doc = null;

  String get key => doc?.documentID;

  int get timestamp => getValue('timestamp');

  Map<String, dynamic> get values => doc?.data ?? _values;

  @mustCallSuper
  BaseFirebaseEntity.fromSnapshot(this.doc);

  dynamic getValue(String key) => values[key];

  void setValue(String key, dynamic value) => this.values[key] = value;

  @mustCallSuper
  Map<String, dynamic> toMap() {
    values['timestamp'] ??= new DateTime.now().millisecondsSinceEpoch;
    values['arquived'] ??= false;
    return values;
  }

  @override
  String toString() {
    return '$runtimeType {key: $key}';
  }

  void updateFromSnapshot(DocumentSnapshot snapshot) {
    this.doc = snapshot;
  }

  bool get archived => getValue('archived') ?? false;

  set archived(bool archived) => setValue('archived', archived);
}
