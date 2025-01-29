import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<bool> checkServerHealth() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.healthCheckUrl));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error checking server health: $e');
      return false;
    }
  }

  Future<File?> applyEdgeDetection(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.edgeDetectionUrl),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final bytes = await response.stream.toBytes();
        final tempDir = await Directory.systemTemp.createTemp();
        final tempFile = File('${tempDir.path}/edge_detected.png');
        await tempFile.writeAsBytes(bytes);
        return tempFile;
      }
      return null;
    } catch (e) {
      debugPrint('Error applying edge detection: $e');
      return null;
    }
  }

  Future<File?> applyBlur(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.blurUrl),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final bytes = await response.stream.toBytes();
        final tempDir = await Directory.systemTemp.createTemp();
        final tempFile = File('${tempDir.path}/blurred.png');
        await tempFile.writeAsBytes(bytes);
        return tempFile;
      }
      return null;
    } catch (e) {
      debugPrint('Error applying blur: $e');
      return null;
    }
  }
}
