import 'dart:async';

import 'package:crochet_land/model/base_firebase_entity.dart';
import 'package:crochet_land/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// Firebase config


abstract class FirebaseUserAwareCrudRepository<T extends BaseFirebaseEntity>
    extends FirebaseCrudRepository {
  static Auth auth = new Auth();

  FirebaseUserAwareCrudRepository(String entityName)
      : super._ref(FirebaseCrudRepository.firebase
      .reference()
      .child(auth.user.uid)
      .child(entityName)
    ..keepSynced(true));
}

abstract class FirebaseCrudRepository<T extends BaseFirebaseEntity> {

  static FirebaseDatabase firebase = FirebaseDatabase.instance
    ..setPersistenceEnabled(true);
  final DatabaseReference databaseReference;

  /// Allow other crud classes to pass their own ref
  FirebaseCrudRepository._ref(this.databaseReference);

  FirebaseCrudRepository(String entityName) : databaseReference =
  firebase
      .reference()
      .child(entityName);

  Future<bool> beforeInsert(T entity) async => true;

  afterInsert(T entity) async {}

  Future<bool> beforeUpdate(T entity) async => true;

  afterUpdate(T entity) async {}

  Future<T> insert(T entity) async {
    assert(entity != null);
    if (await beforeInsert(entity)) {
      if (entity is BaseFirebaseEntity) {
        final newEntityRef = databaseReference.push();
        await newEntityRef.set(entity.toMap());
        afterInsert(entity);
        entity.updateFromSnapshot(await newEntityRef.once());
      }
    }
    return entity;
  }

  Future<T> update(T entity) async {
    var entityRef = databaseReference
        .child(entity.key);
    await entityRef
        .update(entity.toMap());
    entity.updateFromSnapshot(await entityRef.once());
    return entity;
  }


  DatabaseReference entityReference(String key) {
    return databaseReference.child(key);
  }


}