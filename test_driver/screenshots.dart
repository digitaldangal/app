import 'dart:io' as Io;

import 'package:image/image.dart';

class AndroidScreenshots {

  static final folder = 'android/fastlane/metadata/android/pt-BR/images';

  static final phone = '$folder/phoneScreenshots';

  static void save(String type, String name, List<int> screenshotData) {
    Image loginScreen = decodePng(screenshotData);
    new Io.File('${AndroidScreenshots.phone}/login.png')
      ..writeAsBytesSync(encodePng(loginScreen));
  }

}