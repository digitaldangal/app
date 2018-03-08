import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import './screenshots.dart';
// Imports the Flutter Driver API


void main() {
  group('Login integration tests', () {
    FlutterDriver driver;

    setUpAll(() async {
      // Connects to the app
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        // Closes the connection
        driver.close();
      }
    });

    test('login loads ', () async {
      await driver.waitFor(find.text('Login com Google'));
      await driver.waitFor(find.text('Login com Facebook'));


      AndroidScreenshots.save(
          AndroidScreenshots.phone, 'login', await driver.screenshot());
    });
  });
}

