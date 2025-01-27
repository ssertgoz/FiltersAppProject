import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_filtering_app/services/image_processing_bindings.dart';

import 'screens/home_screen.dart';

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
      title: 'Image Filter App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.pink,
          secondary: Colors.pink,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
