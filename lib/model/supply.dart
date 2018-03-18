import 'package:crochet_land/model/base_firebase_entity.dart';
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

final supplyTypes = <String>[
  'Hook', 'Yarn', 'Acessories', 'Other'
];


const SupplyTypePricingMap = const <String, SupplyPricingType>{
  'Hook': SupplyPricingType.DURABLE,
  'Yarn': SupplyPricingType.CONSUMABLE,
  'Other': SupplyPricingType.CONSUMABLE,
  'Acessories': SupplyPricingType.CONSUMABLE
};

//TODO i18n
final Map<String, String> supplyTypeNames = {
  'Hook': 'Agulha',
  'Yarn': 'Linha',
  'Other': 'Outros',
  'Acessories': 'Acessórios',
};

const defaultSupplyType = 'Yarn';

class Supply extends BaseFirebaseEntity {


  String get type => getValue('type') ?? defaultSupplyType;

  double get price => double.parse(getValue('price')?.toString() ?? '0');

  String get name => getValue('name');

  set type(String type) => setValue('type', type);

  set price(double price) => setValue('price', price);

  set name(String name) => setValue('name', name);

  SupplyPricingType get pricingType =>
      getValue('pricingType') ?? SupplyTypePricingMap[type] ??
          SupplyPricingType.CONSUMABLE;


  Supply();

  Supply.fromSnapshot(snapshot) : super.fromSnapshot(snapshot);

}