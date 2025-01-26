#ifndef IMAGE_PROCESSOR_H
#define IMAGE_PROCESSOR_H

#include <opencv2/opencv.hpp>

extern "C" {
    // Basic image processing functions
    void processGrayscale(const char* inputPath, const char* outputPath);
    void processBlur(const char* inputPath, const char* outputPath, double sigma);
    void processSharpen(const char* inputPath, const char* outputPath, double strength);
    void processEdgeDetection(const char* inputPath, const char* outputPath);
    void processBrightness(const char* inputPath, const char* outputPath, double factor);
    void processContrast(const char* inputPath, const char* outputPath, double factor);
    void processSaturation(const char* inputPath, const char* outputPath, double factor);
    void processSepia(const char* inputPath, const char* outputPath);
    void processInvert(const char* inputPath, const char* outputPath);
    void processThreshold(const char* inputPath, const char* outputPath, double threshold);
}

#endif // IMAGE_PROCESSOR_H 