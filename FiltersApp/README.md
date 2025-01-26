# Filters App

A Flutter application that implements various image filters using OpenCV native code.

## Android Setup

### Prerequisites
- Android Studio
- CMake (version 3.22.1 or higher)
- Android NDK
- OpenCV Android SDK

### Project Structure

## Project Structure

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

    android/
    ├── app/
    │ ├── src/
    │ │ └── main/
    │ │ ├── cpp/ # Native code directory
    │ │ │ ├── CMakeLists.txt # CMake configuration
    │ │ │ ├── image_processor.cpp # Native implementations
    │ │ │ └── opencv/ # OpenCV SDK directory
    │ │ │ └── sdk/
    │ │ │ ├── native/
    │ │ │ │ ├── jni/ # OpenCV headers
    │ │ │ │ └── libs/ # OpenCV .so files
    │ │ └── kotlin/ # Kotlin source files
    │ └── build.gradle # App-level Gradle config
    └── build.gradle # Project-level Gradle config


### Setup Steps

1. **Download OpenCV Android SDK**
   - Download OpenCV Android SDK from [OpenCV Releases](https://opencv.org/releases/)
   - Extract the SDK
   - Copy the SDK files to `android/app/src/main/cpp/opencv/`

2. **Configure build.gradle**
   Add the following configurations to `android/app/build.gradle`:
   ```groovy
   android {
       defaultConfig {
           ndk {
               abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86', 'x86_64'
           }
           
           externalNativeBuild {
               cmake {
                   cppFlags "-frtti -fexceptions"
                   arguments "-DANDROID_STL=c++_shared",
                            "-DANDROID_PLATFORM=android-21",
                            "-DCMAKE_BUILD_TYPE=Debug",
                            "-DOpenCV_DIR=${project.projectDir}/src/main/cpp/opencv/sdk/native/jni"
               }
           }
       }

       externalNativeBuild {
           cmake {
               path "src/main/cpp/CMakeLists.txt"
               version "3.22.1"
           }
       }

       sourceSets {
           main {
               jniLibs.srcDirs = ['src/main/cpp/opencv/sdk/native/libs']
           }
       }
   }
   ```

3. **Configure CMakeLists.txt**
   Create `android/app/src/main/cpp/CMakeLists.txt`:
   ```cmake
   cmake_minimum_required(VERSION 3.4.1)
   project(ImageProcessor)

   # Set OpenCV path and include directories
   set(OpenCV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/opencv/sdk/native/jni")
   set(OpenCV_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/opencv/sdk/native/jni/include")

   # Add OpenCV's CMake directory to the module path
   list(APPEND CMAKE_MODULE_PATH "${OpenCV_DIR}")

   # Set library output directory
   set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)

   # Include OpenCV configuration
   include("${OpenCV_DIR}/OpenCVConfig.cmake")

   # Add your native library
   add_library(
       image_processor
       SHARED
       ${CMAKE_CURRENT_SOURCE_DIR}/image_processor.cpp
   )

   # Include directories
   target_include_directories(image_processor PRIVATE
       ${OpenCV_INCLUDE_DIRS}
       ${CMAKE_CURRENT_SOURCE_DIR}
   )

   # Link libraries
   target_link_libraries(
       image_processor
       ${OpenCV_LIBS}
   )
   ```

4. **Native Code Implementation**
   Create your C++ implementation in `android/app/src/main/cpp/image_processor.cpp`. Remember to:
   - Include necessary OpenCV headers
   - Use appropriate namespace declarations
   - Implement JNI functions with correct method signatures

### Troubleshooting

1. **CMake Not Found**
   - Make sure CMake is installed via Android Studio's SDK Manager
   - Verify the CMake version in build.gradle matches the installed version

2. **OpenCV Not Found**
   - Verify OpenCV SDK is in the correct location
   - Check OpenCV_DIR path in CMakeLists.txt
   - Ensure OpenCV native libraries are present in the SDK

3. **Build Errors**
   - Run `./gradlew clean` before rebuilding
   - Check for any duplicate native libraries
   - Verify ABI filters match your device architecture

### Supported Features

- Image sharpening
- Edge detection
- Brightness adjustment
- Contrast adjustment
- Saturation adjustment
- Grayscale conversion
- Blur effect
- Sepia filter
- Threshold filter
- Image inversion

## License

[Your License Here]
