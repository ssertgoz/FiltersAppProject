cmake_minimum_required(VERSION 3.4.1)

# Set OpenCV path - update this path to your OpenCV Android SDK location
set(OpenCV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../opencv/sdk/native/jni")
find_package(OpenCV REQUIRED)

# Add your native library
add_library(
    image_processor
    SHARED
    ${CMAKE_CURRENT_SOURCE_DIR}/../../src/cpp/image_processor.cpp
)

# Include directories
target_include_directories(image_processor PRIVATE
    ${OpenCV_INCLUDE_DIRS}
)

# Link libraries
target_link_libraries(
    image_processor
    ${OpenCV_LIBS}
) 