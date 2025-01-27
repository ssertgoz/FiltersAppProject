import 'dart:io';
import 'dart:isolate';

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
        // Initialize bindings in isolate with error handling
        if (!ImageProcessingBindings.isInitialized) {
          try {
            ImageProcessingBindings.initialize();
          } catch (e) {
            message.responsePort.send(null);
            return;
          }
        }

        final inputPathPtr = message.inputPath.toNativeUtf8();
        final outputPath = await _createOutputFile(message.inputPath);
        final outputPathPtr = outputPath.toNativeUtf8();

        try {
          // Apply filter with error handling
          switch (message.filter.type) {
            case FilterType.brightness:
              ImageProcessingBindings.processBrightness(
                  inputPathPtr, outputPathPtr, message.filter.intensity ?? 0.0);
              break;
            case FilterType.contrast:
              ImageProcessingBindings.processContrast(
                  inputPathPtr, outputPathPtr, message.filter.intensity ?? 1.0);
              break;
            case FilterType.saturation:
              ImageProcessingBindings.processSaturation(
                  inputPathPtr, outputPathPtr, message.filter.intensity ?? 1.0);
              break;
            case FilterType.sepia:
              ImageProcessingBindings.processSepia(inputPathPtr, outputPathPtr);
              break;
            case FilterType.grayscale:
              ImageProcessingBindings.processGrayscale(
                  inputPathPtr, outputPathPtr);
              break;
            case FilterType.blur:
              ImageProcessingBindings.processBlur(
                  inputPathPtr, outputPathPtr, message.filter.intensity ?? 5.0);
              break;
            case FilterType.sharpen:
              ImageProcessingBindings.processSharpen(
                  inputPathPtr, outputPathPtr, message.filter.intensity ?? 0.5);
              break;
            case FilterType.edgeDetection:
              ImageProcessingBindings.processEdgeDetection(
                  inputPathPtr, outputPathPtr);
              break;
            case FilterType.invert:
              ImageProcessingBindings.processInvert(
                  inputPathPtr, outputPathPtr);
              break;
            case FilterType.threshold:
              ImageProcessingBindings.processThreshold(inputPathPtr,
                  outputPathPtr, message.filter.intensity ?? 128.0);
              break;
            default:
              message.responsePort.send(null);
              return;
          }

          // Verify the output file exists
          final outputFile = File(outputPath);
          if (!outputFile.existsSync()) {
            message.responsePort.send(null);
            return;
          }

          // Free native memory
          calloc.free(inputPathPtr);
          calloc.free(outputPathPtr);

          message.responsePort.send(outputPath);
        } catch (e) {
          message.responsePort.send(null);
        }
      } catch (e) {
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
