import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

enum SupplyPricingType {
  DURABLE,
  CONSUMABLE
}

final supplyPricingTypeNames = const {
  SupplyPricingType.DURABLE: 'Duráveis',
  SupplyPricingType.CONSUMABLE: 'Consumíveis',
};

final supplyPricingTypeIcons = const {
  SupplyPricingType.DURABLE: Icons.all_inclusive,
  SupplyPricingType.CONSUMABLE: Icons.refresh,
};


enum SupplyType {
  HOOK,
  YARN,
  ACCESSORIES,
  OTHER
}

const SupplyTypePricingMap = const <SupplyType, SupplyPricingType>{
  SupplyType.HOOK: SupplyPricingType.DURABLE,
  SupplyType.YARN: SupplyPricingType.CONSUMABLE,
  SupplyType.OTHER: SupplyPricingType.CONSUMABLE,
  SupplyType.ACCESSORIES: SupplyPricingType.CONSUMABLE
};

//TODO i18n
final Map<SupplyType, String> supplyTypeNames = {
  SupplyType.HOOK: 'Agulha',
  SupplyType.YARN: 'Linha',
  SupplyType.OTHER: 'Outros',
  SupplyType.ACCESSORIES: 'Acessórios',
};

class Supply {

  String key;

  Map<String, dynamic> _values = {};

  SupplyType get type => _values['type'];

  double get price => _values['price'];

  String get name => _values['name'];

  set type(SupplyType type) => _values['type'] = type;

  set price(double price) => _values['price'] = price;

  set name(String name) => _values['name'] = name;

  SupplyPricingType get pricingType =>
      _values['pricingType'] ?? SupplyTypePricingMap[type] ??
          SupplyPricingType.CONSUMABLE;


  Supply();

  Supply.fromSnapshot(DataSnapshot snapshot){
    this.key = snapshot.key;
    this._values = snapshot.value;
  }

  toMap() {
    _values['timestamp'] ??= ServerValue.timestamp;
    return _values;
  }


}