import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_processing_service.dart';
import '../models/filter.dart';
import 'dart:io';

final imageProvider = StateNotifierProvider<ImageNotifier, ImageState>((ref) {
  return ImageNotifier();
});

class ImageState {
  final File? currentImage;
  final File? originalImage;
  final bool isProcessing;

  ImageState({
    this.currentImage,
    this.originalImage,
    this.isProcessing = false,
  });

  ImageState copyWith({
    File? currentImage,
    File? originalImage,
    bool? isProcessing,
  }) {
    return ImageState(
      currentImage: currentImage ?? this.currentImage,
      originalImage: originalImage ?? this.originalImage,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class ImageNotifier extends StateNotifier<ImageState> {
  ImageNotifier() : super(ImageState());
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final file = File(image.path);
        state = state.copyWith(
          currentImage: file,
          originalImage: file,
        );
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> applyFilter(Filter filter) async {
    if (state.originalImage == null) return;

    state = state.copyWith(isProcessing: true);
    
    try {
      final processedImage = await ImageProcessingService.applyFilter(
        state.originalImage!,
        filter,
      );
      
      if (processedImage != null) {
        state = state.copyWith(
          currentImage: processedImage,
          isProcessing: false,
        );
      }
    } catch (e) {
      print('Error applying filter: $e');
      state = state.copyWith(isProcessing: false);
    }
  }

  void clearImage() {
    state = ImageState();
  }
} 