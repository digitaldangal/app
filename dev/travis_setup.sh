#!/bin/bash
# install flutter
git clone https://github.com/flutter/flutter.git -b beta --depth 1
export PATH=$(pwd)/flutter/bin:$PATH

export FLUTTER_HOME=$(pwd)/flutter

echo $G_SERVICES_JSON | base64 --decode >  android/app/google-services.json

if [ -n "$TRAVIS" ]; then

  # Android SDK only needed to build the app on build_and_deploy_gallery Linux shard.
  if [ "$TRAVIS_OS_NAME" = "linux" ] ; then
    # Background for not using Travis's built-in Android tags
    # https://github.com/flutter/plugins/pull/145
    # Copied from https://github.com/flutter/plugins/blame/master/.travis.yml
    wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
    mkdir android-sdk
    unzip -qq sdk-tools-linux-3859397.zip -d android-sdk
    export ANDROID_HOME=$(pwd)/android-sdk
    export PATH=$(pwd)/android-sdk/tools/bin:$PATH
    export PATH=$(pwd)/android-sdk/tools:$PATH # so we have also android on the path
    export PATH=$(pwd)/android-sdk/platform-tools:$PATH # so we have adb
    mkdir -p /home/travis/.android # silence sdkmanager warning
    set +x # Travis's env variable hiding is a bit wonky. Don't echo back this line.
    if [ -n "$ANDROID_UPLOAD_KEY" ]; then
      echo "$ANDROID_UPLOAD_KEY" | base64 --decode > /home/travis/.android/debug.keystore
    fi
    set -x
    echo 'count=0' > /home/travis/.android/repositories.cfg # silence sdkmanager warning
    # suppressing output of sdkmanager to keep log under 4MB (travis limit)
    echo y | sdkmanager "tools" >/dev/null
    echo y | sdkmanager "platform-tools" >/dev/null
    echo y | sdkmanager "build-tools;26.0.3" >/dev/null
    echo y | sdkmanager "platforms;android-26" >/dev/null
    echo y | sdkmanager "platforms;android-25" >/dev/null
    echo y | sdkmanager "extras;android;m2repository" >/dev/null
    echo y | sdkmanager "extras;google;m2repository" >/dev/null
    echo y | sdkmanager "patcher;v4" >/dev/null
    sdkmanager --list
    wget http://services.gradle.org/distributions/gradle-4.1-bin.zip
    unzip -qq gradle-4.1-bin.zip
    export GRADLE_HOME=$PWD/gradle-4.1
    export PATH=$GRADLE_HOME/bin:$PATH
    gradle -v

    if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "add_some_tests" ]]; then

    # create android emulator
    echo y | sdkmanager "emulator" >/dev/null
    echo y | sdkmanager "system-images;android-26;google_apis;armeabi-v7a" >/dev/null
    avdmanager create avd --force -n test3 -k 'system-images;android-25;google_apis;armeabi-v7a'  --abi armeabi-v7a

    # start emulator
    (cd android-sdk/tools/ &&  emulator -avd test -no-audio -no-window &)

    adb wait-for-device
    adb shell input keyevent 82 &


    fi

  fi
fi

flutter doctor

# disable analytics on the bots and download Flutter dependencies
flutter config --no-analytics

# run pub get in all the repo packages
flutter update-packages
