#!/bin/bash

# Exit on error
set -e

echo "Checking OpenCV installation..."
OPENCV_PATH="android/app/src/main/cpp/opencv"
if [ ! -d "$OPENCV_PATH" ]; then
    echo "OpenCV not found in $OPENCV_PATH"
    echo "Please make sure OpenCV is installed in the correct location"
    echo "You can manually copy your downloaded OpenCV SDK to: $OPENCV_PATH"
    exit 1
else
    echo "OpenCV found in $OPENCV_PATH"
fi

echo "Creating build directories..."
mkdir -p android/app/src/main/cpp/build
mkdir -p android/app/src/main/jniLibs/arm64-v8a
mkdir -p android/app/src/main/jniLibs/armeabi-v7a
mkdir -p android/app/src/main/jniLibs/x86
mkdir -p android/app/src/main/jniLibs/x86_64

echo "Building native library..."
cd android

# Use Gradle to build the native library
./gradlew clean
./gradlew assembleDebug --info

cd ..

echo "Building Android app..."
flutter clean
flutter pub get
flutter run --debug

# Check if library is installed
echo "Verifying library installation..."
adb shell "run-as com.filtersApp.filters_app ls -l /data/data/com.filtersApp.filters_app/lib" 