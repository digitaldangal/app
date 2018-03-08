import 'package:crochet_land/services/abstract_firebase_service.dart';


class ConfigRepository extends FirebaseCrudRepository {

  static final ConfigRepository _instance = new ConfigRepository._private();

  factory ConfigRepository () => _instance;

  ConfigRepository._private() : super('configs');

}