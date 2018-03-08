import 'dart:async';

import 'package:crochet_land/model/supply.dart';
import 'package:crochet_land/services/abstract_firebase_service.dart';


class SupplyRepository extends FirebaseUserAwareCrudRepository<Supply> {

  static final SupplyRepository _instance = new SupplyRepository._private();


  factory SupplyRepository() => _instance;

  SupplyRepository._private() : super('supplies');

  Future<List<Supply>> loadFromKeys(List<String> supplyKeys) async {
    return await Future.wait(
        supplyKeys
            .map((key) async =>
            databaseReference.child(key).once().then((snapshot) =>
            new Supply
                .fromSnapshot(snapshot)))

    );
  }

}