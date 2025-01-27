import 'package:filters_app/services/image_processing_bindings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    ImageProcessingBindings.initialize();
    debugPrint('Native image processing initialized successfully');
  } catch (e) {
    debugPrint('Error initializing native processing: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FiltersApp',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home: FutureBuilder(
        future: Future.delayed(
            const Duration(seconds: 2)), // Show splash for 2 seconds
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          return const HomeScreen();
        },
      ),
    );
  }
}
