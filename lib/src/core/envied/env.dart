import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'FIREBASE_API_KEY', obfuscate: true)
  static final String fireBaseUrl = _Env.fireBaseUrl;
  @EnviedField(varName: 'AUTH_DOMAIN', obfuscate: true)
  static final String authDomain = _Env.authDomain;
  @EnviedField(varName: 'PROJECT_ID', obfuscate: true)
  static final String projectId = _Env.projectId;
  @EnviedField(varName: 'STORAGE_BUCKET', obfuscate: true)
  static final String storageBucket = _Env.storageBucket;
  @EnviedField(varName: 'MESSAGING_SENDER_ID', obfuscate: true)
  static final String messagingSenderId = _Env.messagingSenderId;
  @EnviedField(varName: 'APP_ID', obfuscate: true)
  static final String appId = _Env.appId;
  @EnviedField(varName: 'MEASUREMENT_ID', obfuscate: true)
  static final String measurementId = _Env.measurementId;
}

//
// abstract class CollectionNames {
//   static String get delta => 'delta';
//   static String get deltaDocumentsPath => 'collections.$delta.documents';
//   static String get pages => 'pages';
//   static String get pagesDocumentsPath => 'collections.$pages.documents';
// }
