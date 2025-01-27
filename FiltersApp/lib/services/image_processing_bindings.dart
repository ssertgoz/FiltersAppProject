import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';

// FFI type definitions
typedef ProcessImageFunc = Void Function(Pointer<Utf8>, Pointer<Utf8>);
typedef ProcessImageWithParamFunc = Void Function(
    Pointer<Utf8>, Pointer<Utf8>, Double);

// Dart function signatures
typedef ProcessImageDart = void Function(Pointer<Utf8>, Pointer<Utf8>);
typedef ProcessImageWithParamDart = void Function(
    Pointer<Utf8>, Pointer<Utf8>, double);

class ImageProcessingBindings {
  static late final DynamicLibrary _lib;
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  // Function pointers
  static late final ProcessImageDart processGrayscale;
  static late final ProcessImageWithParamDart processBlur;
  static late final ProcessImageWithParamDart processSharpen;
  static late final ProcessImageDart processEdgeDetection;
  static late final ProcessImageWithParamDart processBrightness;
  static late final ProcessImageWithParamDart processContrast;
  static late final ProcessImageWithParamDart processSaturation;
  static late final ProcessImageDart processSepia;
  static late final ProcessImageDart processInvert;
  static late final ProcessImageWithParamDart processThreshold;

  static void initialize() {
    if (_isInitialized) return;

    try {
      final libraryPath = _getLibraryPath();
      _lib = DynamicLibrary.open(libraryPath);
      _initializeFunctions();
      _isInitialized = true;
    } catch (e, stackTrace) {
      debugPrint('Failed to initialize native library: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  static void _initializeFunctions() {
    processGrayscale = _lib
        .lookupFunction<ProcessImageFunc, ProcessImageDart>('processGrayscale');
    processBlur = _lib.lookupFunction<ProcessImageWithParamFunc,
        ProcessImageWithParamDart>('processBlur');
    processSharpen = _lib.lookupFunction<ProcessImageWithParamFunc,
        ProcessImageWithParamDart>('processSharpen');
    processEdgeDetection =
        _lib.lookupFunction<ProcessImageFunc, ProcessImageDart>(
            'processEdgeDetection');
    processBrightness = _lib.lookupFunction<ProcessImageWithParamFunc,
        ProcessImageWithParamDart>('processBrightness');
    processContrast = _lib.lookupFunction<ProcessImageWithParamFunc,
        ProcessImageWithParamDart>('processContrast');
    processSaturation = _lib.lookupFunction<ProcessImageWithParamFunc,
        ProcessImageWithParamDart>('processSaturation');
    processSepia =
        _lib.lookupFunction<ProcessImageFunc, ProcessImageDart>('processSepia');
    processInvert = _lib
        .lookupFunction<ProcessImageFunc, ProcessImageDart>('processInvert');
    processThreshold = _lib.lookupFunction<ProcessImageWithParamFunc,
        ProcessImageWithParamDart>('processThreshold');
  }

  static String _getLibraryPath() {
    if (Platform.isAndroid) {
      try {
        final appId = "com.filtersApp.filters_app";
        // Try multiple possible paths
        final possiblePaths = [
          'libimage_processor.so',
          '/data/data/$appId/lib/libimage_processor.so',
          '/data/app/$appId/lib/arm64-v8a/libimage_processor.so',
          '/data/app/$appId-1/lib/arm64-v8a/libimage_processor.so',
        ];

        for (final path in possiblePaths) {
          final file = File(path);
          if (file.existsSync()) {
            return path;
          }
        }

        // Default to the first path if none exist
        return possiblePaths.first;
      } catch (e) {
        debugPrint('Error checking library paths: $e');
        rethrow;
      }
    } else if (Platform.isIOS) {
      return 'image_processor.framework/image_processor';
    } else if (Platform.isWindows) {
      return 'image_processor.dll';
    } else if (Platform.isMacOS) {
      return 'libimage_processor.dylib';
    } else if (Platform.isLinux) {
      return 'libimage_processor.so';
    }
    throw UnsupportedError('Unsupported platform');
  }
}
