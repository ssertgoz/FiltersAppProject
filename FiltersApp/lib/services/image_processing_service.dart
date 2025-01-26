import 'dart:io';
import 'dart:isolate';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:ffi/ffi.dart';
import '../models/filter.dart';
import 'image_processing_bindings.dart';
import 'isolate_worker.dart';

class ImageProcessingService {
  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;

  Future<void> _initializeIsolate() async {
    if (_isolate != null) return;

    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(isolateFunction, _receivePort!.sendPort);
    _sendPort = await _receivePort!.first;
  }

  Future<File?> processImage(File inputImage, Filter filter) async {
    try {
      await _initializeIsolate();
      
      if (_sendPort == null) {
        throw Exception('Failed to initialize isolate');
      }

      final responsePort = ReceivePort();
      _sendPort!.send(FilterMessage(
        inputImage.path, 
        filter,
        responsePort.sendPort
      ));

      final result = await responsePort.first;
      responsePort.close();

      if (result == null) {
        print('No result from isolate');
        return null;
      }

      return File(result as String);
    } catch (e) {
      print('Error processing image: $e');
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

  int _filterCounter = 0;

  Future<File> _createOutputFile(File inputFile) async {
    final directory = await getTemporaryDirectory();
    final extension = path.extension(inputFile.path);
    
    // Reset counter if it gets too large
    if (_filterCounter > 1000) {
      _filterCounter = 0;
    }
    
    final outputPath = path.join(
      directory.path,
      'filtered_${_filterCounter++}$extension'
    );
    return File(outputPath);
  }
}
