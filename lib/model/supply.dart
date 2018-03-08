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

class Supply extends BaseFirebaseEntity {


  SupplyType get type => getValue('type');

  double get price => getValue('price');

  String get name => getValue('name');

  set type(SupplyType type) => setValue('type', type);

  set price(double price) => setValue('price', price);

  set name(String name) => setValue('name', name);

  SupplyPricingType get pricingType =>
      getValue('pricingType') ?? SupplyTypePricingMap[type] ??
          SupplyPricingType.CONSUMABLE;


  Supply();

  Supply.fromSnapshot(snapshot) : super.fromSnapshot(snapshot);

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();

    return map;
  }


}