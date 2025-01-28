class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://localhost:8000';
  
  // Endpoints
  static const String healthCheck = '/';
  static const String edgeDetection = '/filter/edge-detection';
  static const String blur = '/filter/blur';

  // Full URLs
  static String get edgeDetectionUrl => '$baseUrl$edgeDetection';
  static String get blurUrl => '$baseUrl$blur';
  static String get healthCheckUrl => '$baseUrl$healthCheck';
} 