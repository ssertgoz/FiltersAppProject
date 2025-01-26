import 'dart:isolate';
import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import '../models/filter.dart';
import 'image_processing_bindings.dart';

// Message to be sent to isolate
class FilterMessage {
  final String inputPath;
  final Filter filter;
  final SendPort responsePort;

  FilterMessage(this.inputPath, this.filter, this.responsePort);
}

// Process image in isolate
void isolateFunction(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((message) async {
    if (message is FilterMessage) {
      try {
        print('Isolate: Received filter message for ${message.filter.type}');
        print('Isolate: Filter intensity: ${message.filter.intensity}');
        
        // Initialize bindings in isolate with error handling
        if (!ImageProcessingBindings.isInitialized) {
          try {
            print('Isolate: Initializing FFI bindings...');
            ImageProcessingBindings.initialize();
            print('Isolate: FFI bindings initialized successfully');
          } catch (e) {
            print('Isolate: Failed to initialize FFI bindings: $e');
            message.responsePort.send(null);
            return;
          }
        }

        final inputPathPtr = message.inputPath.toNativeUtf8();
        final outputPath = await _createOutputFile(message.inputPath);
        final outputPathPtr = outputPath.toNativeUtf8();

        print('Isolate: Processing image...');
        print('Isolate: Input path: ${message.inputPath}');
        print('Isolate: Output path: $outputPath');

        try {
          // Apply filter with error handling
          switch (message.filter.type) {
            case FilterType.brightness:
              print('Isolate: Applying brightness filter with intensity: ${message.filter.intensity}');
              ImageProcessingBindings.processBrightness(
                inputPathPtr, 
                outputPathPtr, 
                message.filter.intensity ?? 0.0
              );
              break;
            case FilterType.contrast:
              print('Isolate: Applying contrast filter with intensity: ${message.filter.intensity}');
              ImageProcessingBindings.processContrast(
                inputPathPtr, 
                outputPathPtr, 
                message.filter.intensity ?? 1.0
              );
              break;
            case FilterType.saturation:
              print('Isolate: Applying saturation filter with intensity: ${message.filter.intensity}');
              ImageProcessingBindings.processSaturation(
                inputPathPtr, 
                outputPathPtr, 
                message.filter.intensity ?? 1.0
              );
              break;
            case FilterType.sepia:
              print('Isolate: Applying sepia filter');
              ImageProcessingBindings.processSepia(inputPathPtr, outputPathPtr);
              break;
            case FilterType.grayscale:
              print('Isolate: Applying grayscale filter');
              ImageProcessingBindings.processGrayscale(inputPathPtr, outputPathPtr);
              break;
            case FilterType.blur:
              print('Isolate: Applying blur filter with intensity: ${message.filter.intensity}');
              ImageProcessingBindings.processBlur(
                inputPathPtr, 
                outputPathPtr, 
                message.filter.intensity ?? 5.0
              );
              break;
            case FilterType.sharpen:
              print('Isolate: Applying sharpen filter with intensity: ${message.filter.intensity}');
              ImageProcessingBindings.processSharpen(
                inputPathPtr, 
                outputPathPtr, 
                message.filter.intensity ?? 0.5
              );
              break;
            case FilterType.edgeDetection:
              print('Isolate: Applying edge detection filter');
              ImageProcessingBindings.processEdgeDetection(inputPathPtr, outputPathPtr);
              break;
            case FilterType.invert:
              print('Isolate: Applying invert filter');
              ImageProcessingBindings.processInvert(inputPathPtr, outputPathPtr);
              break;
            case FilterType.threshold:
              print('Isolate: Applying threshold filter with intensity: ${message.filter.intensity}');
              ImageProcessingBindings.processThreshold(
                inputPathPtr, 
                outputPathPtr, 
                message.filter.intensity ?? 128.0
              );
              break;
            default:
              print('Isolate: Unknown filter type: ${message.filter.type}');
              message.responsePort.send(null);
              return;
          }

          print('Isolate: Filter applied successfully');
          
          // Verify the output file exists
          final outputFile = File(outputPath);
          if (!outputFile.existsSync()) {
            print('Isolate: Output file was not created: $outputPath');
            message.responsePort.send(null);
            return;
          }

          // Free native memory
          calloc.free(inputPathPtr);
          calloc.free(outputPathPtr);

          print('Isolate: Sending response with output path: $outputPath');
          message.responsePort.send(outputPath);
        } catch (e) {
          print('Isolate: Error applying filter: $e');
          message.responsePort.send(null);
        }
      } catch (e) {
        print('Isolate: Error in isolate: $e');
        message.responsePort.send(null);
      }
    }
  });
}

Future<String> _createOutputFile(String inputPath) async {
  final directory = Directory.systemTemp;
  final extension = inputPath.split('.').last;
  return '${directory.path}/filtered_${DateTime.now().millisecondsSinceEpoch}.$extension';
}
