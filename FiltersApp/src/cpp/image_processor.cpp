#include "image_processor.h"
#include <opencv2/opencv.hpp>

using namespace cv;

extern "C" {

void* processGrayscale(const char* inputPath, const char* outputPath) {
    Mat image = imread(inputPath);
    if (image.empty()) return nullptr;
    
    Mat gray;
    cvtColor(image, gray, COLOR_BGR2GRAY);
    cvtColor(gray, gray, COLOR_GRAY2BGR);
    imwrite(outputPath, gray);
    return nullptr;
}

void* processBlur(const char* inputPath, const char* outputPath, double sigma) {
    Mat image = imread(inputPath);
    if (image.empty()) return nullptr;
    
    Mat blurred;
    GaussianBlur(image, blurred, Size(0, 0), sigma);
    imwrite(outputPath, blurred);
    return nullptr;
}

void* processSharpen(const char* inputPath, const char* outputPath, double strength) {
    Mat image = imread(inputPath);
    if (image.empty()) return nullptr;
    
    Mat blurred;
    GaussianBlur(image, blurred, Size(0, 0), 3);
    Mat sharpened = image * (1 + strength) - blurred * strength;
    imwrite(outputPath, sharpened);
    return nullptr;
}

void* processEdgeDetection(const char* inputPath, const char* outputPath) {
    Mat image = imread(inputPath);
    if (image.empty()) return nullptr;
    
    Mat edges;
    cvtColor(image, edges, COLOR_BGR2GRAY);
    Canny(edges, edges, 100, 200);
    cvtColor(edges, edges, COLOR_GRAY2BGR);
    imwrite(outputPath, edges);
    return nullptr;
}

void* processBrightness(const char* inputPath, const char* outputPath, double factor) {
    Mat image = imread(inputPath);
    if (image.empty()) return nullptr;
    
    Mat adjusted = image * factor;
    imwrite(outputPath, adjusted);
    return nullptr;
}

void* processContrast(const char* inputPath, const char* outputPath, double factor) {
    Mat image = imread(inputPath);
    if (image.empty()) return nullptr;
    
    Mat adjusted;
    image.convertTo(adjusted, -1, factor, 0);
    imwrite(outputPath, adjusted);
    return nullptr;
}

void* processSaturation(const char* inputPath, const char* outputPath, double factor) {
    Mat image = imread(inputPath);
    if (image.empty()) return nullptr;
    
    Mat hsv;
    cvtColor(image, hsv, COLOR_BGR2HSV);
    vector<Mat> channels;
    split(hsv, channels);
    channels[1] *= factor;
    merge(channels, hsv);
    cvtColor(hsv, image, COLOR_HSV2BGR);
    imwrite(outputPath, image);
    return nullptr;
}

void* processSepia(const char* inputPath, const char* outputPath) {
    Mat image = imread(inputPath);
    if (image.empty()) return nullptr;
    
    Mat sepia;
    Mat kernel = (Mat_<float>(3,3) <<
        0.272, 0.534, 0.131,
        0.349, 0.686, 0.168,
        0.393, 0.769, 0.189);
    transform(image, sepia, kernel);
    imwrite(outputPath, sepia);
    return nullptr;
}

void* processInvert(const char* inputPath, const char* outputPath) {
    Mat image = imread(inputPath);
    if (image.empty()) return nullptr;
    
    Mat inverted = Scalar::all(255) - image;
    imwrite(outputPath, inverted);
    return nullptr;
}

void* processThreshold(const char* inputPath, const char* outputPath, double threshold) {
    Mat image = imread(inputPath);
    if (image.empty()) return nullptr;
    
    Mat gray, binary;
    cvtColor(image, gray, COLOR_BGR2GRAY);
    cv::threshold(gray, binary, threshold, 255, THRESH_BINARY);
    cvtColor(binary, binary, COLOR_GRAY2BGR);
    imwrite(outputPath, binary);
    return nullptr;
}

} 