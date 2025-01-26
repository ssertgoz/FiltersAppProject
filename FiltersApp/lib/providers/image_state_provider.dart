import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class ImageState {
  final File? originalImage;
  final File? currentImage;
  final bool isProcessing;
  final List<File> history;
  final int currentStep;

  ImageState({
    this.originalImage,
    this.currentImage,
    this.isProcessing = false,
    this.history = const [],
    this.currentStep = -1,
  });

  ImageState copyWith({
    File? originalImage,
    File? currentImage,
    bool? isProcessing,
    List<File>? history,
    int? currentStep,
  }) {
    return ImageState(
      originalImage: originalImage ?? this.originalImage,
      currentImage: currentImage ?? this.currentImage,
      isProcessing: isProcessing ?? this.isProcessing,
      history: history ?? this.history,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

final imageStateProvider = StateNotifierProvider<ImageStateNotifier, ImageState>((ref) {
  return ImageStateNotifier();
});

class ImageStateNotifier extends StateNotifier<ImageState> {
  ImageStateNotifier() : super(ImageState());

  // TODO: Implement image state management methods
} 