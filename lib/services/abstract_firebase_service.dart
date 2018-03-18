import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crochet_land/model/base_firebase_entity.dart';
import 'package:crochet_land/services/auth.dart';

/// Firebase config

abstract class FirebaseUserAwareCrudRepository<T extends BaseFirebaseEntity>
    extends FirebaseCrudRepository {
  static Auth auth = new Auth();

  FirebaseUserAwareCrudRepository(String entityName)
      : super._ref(
      FirebaseCrudRepository.firebase.collection('users').document(auth.user.uid).getCollection(
          entityName));
}

abstract class FirebaseCrudRepository<T extends BaseFirebaseEntity> {
  static Firestore firebase = Firestore.instance;
  final CollectionReference databaseReference;

  /// Allow other crud classes to pass their own ref
  FirebaseCrudRepository._ref(this.databaseReference);

  FirebaseCrudRepository(String entityName)
      : databaseReference = Firestore.instance.collection(entityName);

  Future<bool> beforeInsert(T entity) async => true;

  afterInsert(T entity) async {}

  Future<bool> beforeUpdate(T entity) async => true;

  afterUpdate(T entity) async {}

  Future<T> insert(T entity) async {
    assert(entity != null);
    if (await beforeInsert(entity)) {
      if (entity is BaseFirebaseEntity) {
        final newEntityRef = databaseReference.document();
        await newEntityRef.setData(entity.toMap());
        afterInsert(entity);
        entity.updateFromSnapshot(await newEntityRef.get());
      }
    }
    return entity;
  }

  Future<T> update(T entity) async {
    var entityRef = entityReference(entity.key);
    await entityRef.updateData(entity.toMap());
    entity.updateFromSnapshot(await entityRef.get());
    return entity;
  }

  DocumentReference entityReference(String key) {
    return databaseReference.document(key);
  }

  delete(T entity) {
    print('$entity deleted');
    entityReference(entity.key).delete();
  }

  archive(T entity) {
    print('$entity archived');
    entity.archived = true;
    entityReference(entity.key).updateData(entity.toMap());
  }
}
