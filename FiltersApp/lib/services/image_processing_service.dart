import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

import '../models/filter.dart';
import '../models/filter_message.dart';
import 'image_processing_bindings.dart';

class ImageProcessingService {
  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;

  Future<void> _initializeIsolate() async {
    if (_isolate != null) return;

    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
        _ImageProcessingIsolate.run, _receivePort!.sendPort);
    _sendPort = await _receivePort!.first;
  }

  Future<File?> processImage(File inputImage, Filter filter) async {
    try {
      await _initializeIsolate();

      if (_sendPort == null) {
        throw Exception('Failed to initialize isolate');
      }

      final responsePort = ReceivePort();
      _sendPort!
          .send(FilterMessage(inputImage.path, filter, responsePort.sendPort));

      final result = await responsePort.first;
      responsePort.close();

      if (result == null) {
        debugPrint('No result from isolate');
        return null;
      }

      return File(result as String);
    } catch (e) {
      debugPrint('Error processing image: $e');
      return null;
    }
  }

  void dispose() {
    _isolate?.kill();
    _isolate = null;
    _sendPort = null;
    _receivePort?.close();
    _receivePort = null;
  }
}

// Private class to handle isolate-related functionality
class _ImageProcessingIsolate {
  static void run(SendPort sendPort) {
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
                ImageProcessingBindings.processBrightness(inputPathPtr,
                    outputPathPtr, message.filter.intensity ?? 0.0);
                break;
              case FilterType.contrast:
                ImageProcessingBindings.processContrast(inputPathPtr,
                    outputPathPtr, message.filter.intensity ?? 1.0);
                break;
              case FilterType.saturation:
                ImageProcessingBindings.processSaturation(inputPathPtr,
                    outputPathPtr, message.filter.intensity ?? 1.0);
                break;
              case FilterType.sepia:
                ImageProcessingBindings.processSepia(
                    inputPathPtr, outputPathPtr);
                break;
              case FilterType.grayscale:
                ImageProcessingBindings.processGrayscale(
                    inputPathPtr, outputPathPtr);
                break;
              case FilterType.blur:
                ImageProcessingBindings.processBlur(inputPathPtr, outputPathPtr,
                    message.filter.intensity ?? 5.0);
                break;
              case FilterType.sharpen:
                ImageProcessingBindings.processSharpen(inputPathPtr,
                    outputPathPtr, message.filter.intensity ?? 0.5);
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

  static Future<String> _createOutputFile(String inputPath) async {
    final directory = Directory.systemTemp;
    final extension = inputPath.split('.').last;
    return '${directory.path}/filtered_${DateTime.now().millisecondsSinceEpoch}.$extension';
  }
}
