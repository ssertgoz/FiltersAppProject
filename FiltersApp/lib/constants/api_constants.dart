import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  // Base URL - handle different platforms
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    } else if (Platform.isAndroid) {
      // Android emulator needs 10.0.2.2 to connect to host machine
      return 'http://10.0.2.2:8000';
    } else {
      // iOS simulator and desktop can use localhost
      return 'http://localhost:8000';
    }
  }
  
  // Endpoints
  static const String healthCheck = '/';
  static const String edgeDetection = '/filter/edge-detection';
  static const String blur = '/filter/blur';

  // Full URLs
  static String get edgeDetectionUrl => '$baseUrl$edgeDetection';
  static String get blurUrl => '$baseUrl$blur';
  static String get healthCheckUrl => '$baseUrl$healthCheck';
} 