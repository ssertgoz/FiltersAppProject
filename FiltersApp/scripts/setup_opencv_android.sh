#!/bin/bash

# Exit on error
set -e

OPENCV_PATH="android/app/src/main/cpp/opencv"
OPENCV_VERSION="4.8.0"
OPENCV_DOWNLOAD_URL="https://github.com/opencv/opencv/releases/download/${OPENCV_VERSION}/opencv-${OPENCV_VERSION}-android-sdk.zip"

echo "Checking for existing OpenCV installation..."
if [ -d "$OPENCV_PATH" ]; then
    echo "OpenCV already exists in $OPENCV_PATH"
    echo "Skipping download and setup..."
    exit 0
fi

# Create necessary directories
echo "Creating directories..."
mkdir -p android/app/src/main/cpp
mkdir -p android/app/src/main/jniLibs

# Check if opencv.zip already exists
if [ -f "opencv.zip" ]; then
    echo "Found existing opencv.zip"
else
    echo "Downloading OpenCV Android SDK..."
    if command -v curl &> /dev/null; then
        curl -L -o opencv.zip $OPENCV_DOWNLOAD_URL
    elif command -v wget &> /dev/null; then
        wget -O opencv.zip $OPENCV_DOWNLOAD_URL
    else
        echo "Error: Neither curl nor wget is installed. Please install one of them."
        exit 1
    fi
fi

# Extract OpenCV
echo "Extracting OpenCV..."
unzip -q opencv.zip

# Move OpenCV to the Android project
echo "Moving OpenCV to Android project..."
mv OpenCV-android-sdk android/app/src/main/cpp/opencv

# Copy native libraries
echo "Copying native libraries..."
cp -r android/app/src/main/cpp/opencv/sdk/native/libs/* android/app/src/main/jniLibs/

# Clean up
echo "Cleaning up..."
rm opencv.zip

echo "OpenCV setup completed successfully!"

# Print the location of important files for verification
echo "OpenCV locations:"
echo "SDK: $OPENCV_PATH"
echo "Libraries: android/app/src/main/jniLibs/"
echo "Headers: $OPENCV_PATH/sdk/native/jni/include/" 