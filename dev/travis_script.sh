#!/bin/bash

export PATH=$(pwd)/flutter/bin:$PATH
export FLUTTER_HOME=$(pwd)/flutter

export PATH="$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"

flutter test --coverage

cat coverage/lcov.info | codacy-coverage

# never managed to get the emulator up and running on travis
# flutter drive --target=test_driver/login.dart


  echo "Building and deploying Flutter "
  if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    echo "Building Crochet.land for Android..."
    export ANDROID_HOME=$(pwd)/android-sdk
    flutter build apk --release
    echo "Android Crochet.land built"
    if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "master" ]]; then
      echo "Deploying to Play Store..."
      (cd android; bundle install && bundle exec fastlane deploy_beta)
    else
      echo "Crochet.land is only deployed to the Play Store on merged master branch commits"
    fi
  elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
    echo "Building Crochet.land for iOS..."
    flutter build ios --release --no-codesign
    echo "iOS Crochet.land built"
    if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "master" ]]; then
      echo "Re-building with distribution profile and deploying to TestFlight..."
      # TODO (cd ios; bundle install && bundle exec fastlane build_and_deploy_testflight)
    else
      echo "Crochet.land is only deployed to the TestFlight on merged master branch commits"
    fi
  fi
