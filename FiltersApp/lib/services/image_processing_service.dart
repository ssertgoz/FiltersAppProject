import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:ffi/ffi.dart';
import '../models/filter.dart';
import 'image_processing_bindings.dart';

class ImageProcessingService {
  static Future<File?> applyFilter(File inputImage, Filter filter) async {
    if (!ImageProcessingBindings.isInitialized) {
      print('Native processing not initialized');
      return inputImage;  // Return original image if native processing is not available
    }

    try {
      final outputFile = await _createOutputFile(inputImage);
      final inputPath = inputImage.path.toNativeUtf8();
      final outputPath = outputFile.path.toNativeUtf8();

      try {
        switch (filter.type) {
          case FilterType.original:
            return inputImage;
            
          case FilterType.grayscale:
            ImageProcessingBindings.processGrayscale(inputPath, outputPath);
            break;
            
          case FilterType.blur:
            ImageProcessingBindings.processBlur(
              inputPath, 
              outputPath, 
              filter.intensity ?? 5.0
            );
            break;
            
          case FilterType.sharpen:
            ImageProcessingBindings.processSharpen(
              inputPath, 
              outputPath, 
              filter.intensity ?? 0.5
            );
            break;
            
          case FilterType.edgeDetection:
            ImageProcessingBindings.processEdgeDetection(inputPath, outputPath);
            break;
            
          case FilterType.brightness:
            ImageProcessingBindings.processBrightness(
              inputPath, 
              outputPath, 
              filter.intensity ?? 1.0
            );
            break;
            
          case FilterType.contrast:
            ImageProcessingBindings.processContrast(
              inputPath, 
              outputPath, 
              filter.intensity ?? 1.0
            );
            break;
            
          case FilterType.saturation:
            ImageProcessingBindings.processSaturation(
              inputPath, 
              outputPath, 
              filter.intensity ?? 1.0
            );
            break;
            
          case FilterType.sepia:
            ImageProcessingBindings.processSepia(inputPath, outputPath);
            break;
            
          case FilterType.invert:
            ImageProcessingBindings.processInvert(inputPath, outputPath);
            break;
            
          case FilterType.threshold:
            ImageProcessingBindings.processThreshold(
              inputPath, 
              outputPath, 
              filter.intensity ?? 127.0
            );
            break;
        }

        return outputFile;
      } finally {
        calloc.free(inputPath);
        calloc.free(outputPath);
      }
    } catch (e) {
      print('Error applying filter: $e');
      return null;
    }
  }

  static Future<File> _createOutputFile(File inputFile) async {
    final directory = await getTemporaryDirectory();
    final fileName = path.basenameWithoutExtension(inputFile.path);
    final extension = path.extension(inputFile.path);
    final outputPath = path.join(
      directory.path,
      '${fileName}_filtered_${DateTime.now().millisecondsSinceEpoch}$extension'
    );
    return File(outputPath);
  }
}
