import 'dart:async';

import 'package:crochet_land/model/supply.dart';
import 'package:crochet_land/services/abstract_firebase_service.dart';
import 'package:firebase_database/firebase_database.dart';


class SupplyRepository extends FirebaseUserAwareCrudRepository<Supply> {

  static final SupplyRepository _instance = new SupplyRepository._private();


  factory SupplyRepository() => _instance;

  DatabaseReference supplyReference;

  SupplyRepository._private() : super('supplies');

  Future<List<Supply>> loadFromKeys(List<String> supplyKeys) async {
    Supply yarn = new Supply();
    yarn.type = SupplyType.YARN;
    yarn.name = 'Yarn 1';
    yarn.price = 10.0;

    Supply hook = new Supply();
    hook.type = SupplyType.HOOK;
    hook.name = 'Hook 1';
    hook.price = 12.0;


    List<Supply> supplies = <Supply>[
      yarn, hook, yarn, yarn, yarn, yarn, yarn, yarn,
    ];

    return supplies;
  }

}