# FiltersAppProject

A Flutter application with python backend fast API that implements various image filters using OpenCV native code and python with opencv. 

## Features

- Local image filters using native code (C++)
- Cloud-based filters using FastAPI backend
- Real-time filter preview
- Filter comparison slider
- Filter parameter adjustments
- Save processed images to gallery

## Demo Video




## Prerequisites
- Flutter SDK
- Python 3.8+
- OpenCV
- CMake


## Project Structure

The project consists of two main parts:

### Frontend (FiltersApp)
- Flutter application with native C++ integration
- Real-time image processing
- Intuitive UI for filter selection and adjustment

```
lib/
│   ├── constants/           # App-wide constants
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   ├── app_images.dart
│   │   ├── api_constants.dart
│   │   └── filter_constants.dart
│   ├── models/            # Data models
│   │   ├── filter.dart
│   │   ├── filter_config.dart
│   │   ├── filter_parameter.dart
│   │   └── filter_message.dart
│   ├── providers/         # State management
│   │   ├── filter_provider.dart
│   │   ├── selected_filter_provider.dart
│   │   ├── filter_selection_provider.dart
│   │   ├── image_provider.dart
│   │   └── compare_provider.dart
│   ├── screens/          # UI screens
│   │   ├── home_screen.dart
│   │   └── splash_screen.dart
│   ├── services/         # Business logic
│   │   ├── api_service.dart
│   │   ├── image_processing_bindings.dart
│   │   └── image_processing_service.dart
│   │── widgets/          # Reusable widgets
│   │   ├── filter_parameters_panel.dart
│   │   ├── category_chip.dart
│   │   ├── filter_thumbnail.dart
│   │   ├── filter_categories.dart
│   │   ├── filter_list.dart
│   │   ├── image_editor.dart
│   │   └── comparison_slider.dart
│   └── main.dart
```

### Backend (filters_backend)
- FastAPI server for cloud-based filters
- OpenCV integration for image processing
- RESTful API endpoints

```
filters_backend/
├── app/
│   ├── __init__.py
│   └── main.py           # FastAPI application
├── requirements.txt      # Python dependencies
└── venv/   
```

## Getting Started

## Android Setup

### Prerequisites
- Android Studio
- CMake (version 3.22.1 or higher)
- Android NDK
- OpenCV Android SDK

### Android folder Structure
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








# Image Filters Backend API

A FastAPI-based backend service that provides image processing capabilities using OpenCV. This service is designed to work with the FiltersApp Flutter application.

## Prerequisites

- Python 3.11 or 3.12 (recommended)
- pip (Python package manager)
- Virtual environment module (venv)

## Project Setup

1. Clone the repository (if you haven't already):
```bash
git clone https://github.com/ssertgoz/FiltersAppProject.git
cd filters_backend
```

2. Create a virtual environment:
```bash
# On macOS/Linux
python3.11 -m venv venv

# On Windows
python -m venv venv
```

3. Activate the virtual environment:
```bash
# On macOS/Linux
source venv/bin/activate

# On Windows
.\venv\Scripts\activate
```

4. Install dependencies:
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

## Running the Server

1. Make sure your virtual environment is activated
2. Start the FastAPI server:
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The server will be available at `http://localhost:8000`



## Testing the API

### Using Swagger UI (Recommended)
1. Open `http://localhost:8000/docs` in your web browser
2. You'll see all available endpoints
3. Click on an endpoint to expand it
4. Click "Try it out"
5. Upload an image and execute the request

### Using curl
```bash
# Test health check
curl http://localhost:8000

# Test edge detection (replace path/to/image.jpg with your image path)
curl -X POST -F "file=@path/to/image.jpg" http://localhost:8000/filter/edge-detection -o output.png

# Test blur filter
curl -X POST -F "file=@path/to/image.jpg" http://localhost:8000/filter/blur -o blurred.png
```

## Available Endpoints

- `GET /` - Health check endpoint
- `POST /filter/edge-detection` - Apply edge detection to an image
- `POST /filter/blur` - Apply Gaussian blur to an image

## Response Formats

All image processing endpoints return:
- Success: Processed image in PNG format
- Error: JSON with error details

## Common Issues

1. **Installation Problems**:
   - Make sure you're using Python 3.11 or 3.12
   - Try upgrading pip: `pip install --upgrade pip`
   - If still having issues, delete venv and recreate it

2. **Server Won't Start**:
   - Ensure no other service is using port 8000
   - Check if virtual environment is activated
   - Verify all dependencies are installed

3. **Image Processing Errors**:
   - Verify the image format is supported (JPEG, PNG)
   - Check if the image file exists and is readable

## Development

- The server runs in debug mode by default (--reload flag)
- API documentation is available at `/docs` and `/redoc`
- Logs are printed to the console

## Integration with Flutter App

The Flutter app should be configured to send HTTP requests to:
- Development: `http://localhost:8000`
- Production: Your deployed server URL
