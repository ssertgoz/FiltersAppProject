import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../models/filter.dart';
import '../services/image_processing_service.dart';

class ImageState {
  final File? originalImage;
  final File? currentImage;
  final List<ProcessingStep> history;
  final int currentStepIndex;
  final bool isProcessing;
  final bool hasFilteredImage;

  ImageState({
    this.originalImage,
    this.currentImage,
    this.history = const [],
    this.currentStepIndex = -1,
    this.isProcessing = false,
  }) : hasFilteredImage = history.isNotEmpty;

  ImageState copyWith({
    File? originalImage,
    File? currentImage,
    List<ProcessingStep>? history,
    int? currentStepIndex,
    bool? isProcessing,
  }) {
    return ImageState(
      originalImage: originalImage ?? this.originalImage,
      currentImage: currentImage ?? this.currentImage,
      history: history ?? this.history,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }

  bool get canUndo => currentStepIndex > -1;
  bool get canRedo => currentStepIndex < history.length - 1;
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
  return ImageNotifier(ImageProcessingService());
});

class ImageNotifier extends StateNotifier<ImageState> {
  final ImageProcessingService _imageProcessingService;
  final _picker = ImagePicker();

  ImageNotifier(this._imageProcessingService) : super(ImageState());

  @override
  void dispose() {
    _imageProcessingService.dispose();
    super.dispose();
  }

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

  Future<void> applyFilter(Filter filter, {bool isNewFilter = true}) async {
    if (state.originalImage == null) return;

    state = state.copyWith(isProcessing: true);

    try {
      // Determine input image based on current state and operation
      File inputImage;
      if (state.history.isEmpty) {
        // First filter always uses original image
        inputImage = state.originalImage!;
      } else if (!isNewFilter) {
        // When updating a filter, use the input that was used to create it
        inputImage = state.currentStepIndex == 0 
            ? state.originalImage! 
            : state.history[state.currentStepIndex - 1].image;
      } else {
        // New filter always uses the last filtered image as input
        inputImage = state.history.last.image;
      }

      final processedImage = await _imageProcessingService.processImage(
        inputImage,
        filter,
      );

      if (processedImage != null) {
        List<ProcessingStep> newHistory;

        if (!isNewFilter && state.currentStepIndex >= 0) {
          // Updating existing filter
          newHistory = List<ProcessingStep>.from(state.history);
          newHistory[state.currentStepIndex] = ProcessingStep(
            filter: filter,
            image: processedImage,
          );
          // Remove subsequent steps if we're modifying a previous step
          if (state.currentStepIndex < newHistory.length - 1) {
            newHistory = newHistory.sublist(0, state.currentStepIndex + 1);
          }
        } else {
          // Adding new filter
          newHistory = List<ProcessingStep>.from(state.history)
            ..add(ProcessingStep(
              filter: filter,
              image: processedImage,
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
    final newImage = newIndex >= 0 ? state.history[newIndex].image : state.originalImage;

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

    final newImage = stepIndex >= 0 ? state.history[stepIndex].image : state.originalImage;

    state = state.copyWith(
      currentImage: newImage,
      currentStepIndex: stepIndex,
    );
  }

  void deleteFilter(int index) {
    if (index < 0 || index >= state.history.length) return;

    // Remove the filter and all subsequent filters
    final newHistory = state.history.sublist(0, index);

    // Get the appropriate image to show
    final currentImage = newHistory.isEmpty ? state.originalImage : newHistory.last.image;

    state = state.copyWith(
      currentImage: currentImage,
      history: newHistory,
      currentStepIndex: newHistory.isEmpty ? -1 : newHistory.length - 1,
    );
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13 and above
        final photos = await Permission.photos.request();
        return photos.isGranted;
      } else {
        // Android 12 and below
        final storage = await Permission.storage.request();
        return storage.isGranted;
      }
    }
    return true;
  }

  Future<bool> saveToGallery() async {
    if (state.currentImage == null) return false;

    try {
      // Request permissions first
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        print('Permission denied');
        return false;
      }

      final result = await SaverGallery.saveFile(
          filePath: state.currentImage!.path,
          androidRelativePath: "Pictures/FiltersApp",
          fileName: "filtered_image_${DateTime.now().millisecondsSinceEpoch}.jpg",
          skipIfExists: true);

      if (result.isSuccess) {
        print('Image saved to gallery successfully');
        // Reset the state after successful save
        clearImage();
        return true;
      } else {
        print('Failed to save image: ${result.errorMessage}');
        return false;
      }
    } catch (e) {
      print('Error saving to gallery: $e');
      return false;
    }
  }

  void clearImage() {
    state = ImageState();
  }
}
