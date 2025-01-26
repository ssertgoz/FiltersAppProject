#include <jni.h>
#include <string>
#include <opencv2/opencv.hpp>

// Add all necessary using declarations
using cv::Mat;
using cv::imread;
using cv::imwrite;
using cv::GaussianBlur;
using cv::Size;
using cv::cvtColor;
using cv::Canny;
using cv::Mat_;
using cv::Scalar;
using std::string;
using std::vector;

// Add color space constants
using cv::COLOR_BGR2GRAY;
using cv::COLOR_GRAY2BGR;
using cv::COLOR_BGR2HSV;
using cv::COLOR_HSV2BGR;
using cv::THRESH_BINARY;

extern "C" {

void processGrayscale(const char* inputPath, const char* outputPath) {
    Mat image = imread(inputPath);
    Mat gray;
    cvtColor(image, gray, COLOR_BGR2GRAY);
    cvtColor(gray, gray, COLOR_GRAY2BGR);  // Convert back to BGR for saving
    imwrite(outputPath, gray);
}

void processBlur(const char* inputPath, const char* outputPath, double sigma) {
    cv::Mat image = cv::imread(inputPath);
    cv::Mat blurred;
    cv::GaussianBlur(image, blurred, cv::Size(0, 0), sigma);
    cv::imwrite(outputPath, blurred);
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

JNIEXPORT void JNICALL
Java_com_filtersApp_filters_1app_ImageProcessor_sharpenImage(JNIEnv *env, jobject thiz, jstring input_path,
                                                           jstring output_path, jdouble strength) {
    const char *inputPath = env->GetStringUTFChars(input_path, 0);
    const char *outputPath = env->GetStringUTFChars(output_path, 0);

    cv::Mat image = cv::imread(inputPath);
    if (!image.empty()) {
        cv::Mat blurred;
        cv::GaussianBlur(image, blurred, cv::Size(0, 0), 3);
        cv::Mat sharpened = image * (1 + strength) - blurred * strength;
        cv::imwrite(outputPath, sharpened);
    }

    env->ReleaseStringUTFChars(input_path, inputPath);
    env->ReleaseStringUTFChars(output_path, outputPath);
}

} 