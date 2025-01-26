import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_processing_service.dart';
import '../models/filter.dart';
import 'dart:io';

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

final imageProvider = StateNotifierProvider<ImageNotifier, ImageState>((ref) {
  return ImageNotifier();
});

class ImageNotifier extends StateNotifier<ImageState> {
  ImageNotifier() : super(ImageState());
  final _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final file = File(image.path);
        state = state.copyWith(
          currentImage: file,
          originalImage: file,
          history: [],
          currentStepIndex: -1,
        );
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> applyFilter(Filter filter, {bool isNewFilter = false}) async {
    if (state.originalImage == null) return;

    state = state.copyWith(isProcessing: true);
    
    try {
      // Get input image based on whether it's a new filter or parameter update
      final inputImage = state.history.isEmpty 
          ? state.originalImage!
          : (isNewFilter 
              ? state.history.last.image  // For new filter, use last image
              : state.history[state.currentStepIndex - 1].image);  // For parameter update, use previous image
      
      final processedImage = await ImageProcessingService.applyFilter(
        inputImage,
        filter,
      );
      
      if (processedImage != null) {
        List<ProcessingStep> newHistory;
        
        if (!isNewFilter && state.history.isNotEmpty) {
          // Updating parameters - just update current filter
          newHistory = List<ProcessingStep>.from(state.history);
          newHistory[state.currentStepIndex] = ProcessingStep(
            image: processedImage,
            filter: filter,
          );
        } else {
          // Adding new filter to chain
          newHistory = List<ProcessingStep>.from(state.history);
          newHistory.add(ProcessingStep(
            image: processedImage,
            filter: filter,
          ));
        }

        state = state.copyWith(
          currentImage: processedImage,
          history: newHistory,
          currentStepIndex: isNewFilter ? newHistory.length - 1 : state.currentStepIndex,
          isProcessing: false,
        );
      } else {
        state = state.copyWith(isProcessing: false);
      }
    } catch (e) {
      print('Error applying filter: $e');
      state = state.copyWith(isProcessing: false);
    }
  }

  void undo() {
    if (!state.canUndo) return;
    
    final newIndex = state.currentStepIndex - 1;
    final newImage = newIndex >= 0 
        ? state.history[newIndex].image 
        : state.originalImage;
        
    state = state.copyWith(
      currentImage: newImage,
      currentStepIndex: newIndex,
    );
  }

  void redo() {
    if (!state.canRedo) return;
    
    final newIndex = state.currentStepIndex + 1;
    final newImage = state.history[newIndex].image;
    
    state = state.copyWith(
      currentImage: newImage,
      currentStepIndex: newIndex,
    );
  }

  void clearHistory() {
    state = state.copyWith(
      history: [],
      currentStepIndex: -1,
      currentImage: state.originalImage,
    );
  }

  void goToStep(int stepIndex) {
    if (stepIndex < -1 || stepIndex >= state.history.length) return;
    
    final newImage = stepIndex >= 0 
        ? state.history[stepIndex].image 
        : state.originalImage;
        
    state = state.copyWith(
      currentImage: newImage,
      currentStepIndex: stepIndex,
    );
  }

  void clearImage() {
    state = ImageState();
  }
} 