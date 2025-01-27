import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/filter.dart';

class ImageState {
  final File? originalImage;
  final File? currentImage;
  final bool isProcessing;
  final List<ProcessingStep> history;
  final int currentStepIndex;

  ImageState({
    this.originalImage,
    this.currentImage,
    this.isProcessing = false,
    this.history = const [],
    this.currentStepIndex = -1,
  });

  bool get canUndo => currentStepIndex > -1;
  bool get canRedo => currentStepIndex < history.length - 1;

  ImageState copyWith({
    File? originalImage,
    File? currentImage,
    bool? isProcessing,
    List<ProcessingStep>? history,
    int? currentStepIndex,
  }) {
    return ImageState(
      originalImage: originalImage ?? this.originalImage,
      currentImage: currentImage ?? this.currentImage,
      isProcessing: isProcessing ?? this.isProcessing,
      history: history ?? this.history,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
    );
  }
}

class ProcessingStep {
  final File image;
  final Filter filter;
  final DateTime timestamp;

  ProcessingStep({
    required this.image,
    required this.filter,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

final imageStateProvider =
    StateNotifierProvider<ImageStateNotifier, ImageState>((ref) {
  return ImageStateNotifier();
});

class ImageStateNotifier extends StateNotifier<ImageState> {
  ImageStateNotifier() : super(ImageState());

  // TODO: Implement image state management methods
}
