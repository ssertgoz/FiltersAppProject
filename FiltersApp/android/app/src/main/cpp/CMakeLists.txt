cmake_minimum_required(VERSION 3.4.1)
project(ImageProcessor)

# Set OpenCV path and include directories
set(OpenCV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/opencv/sdk/native/jni")
set(OpenCV_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/opencv/sdk/native/jni/include")

# Add OpenCV's CMake directory to the module path
list(APPEND CMAKE_MODULE_PATH "${OpenCV_DIR}")

# Set library output directory
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)

# Include OpenCV configuration directly
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