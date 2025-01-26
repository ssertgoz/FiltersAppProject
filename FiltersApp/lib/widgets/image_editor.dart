import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/image_provider.dart';
import '../providers/selected_filter_provider.dart';
import '../models/filter.dart';
import '../providers/compare_provider.dart';

class ImageEditor extends ConsumerWidget {
  const ImageEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);
    final isComparing = ref.watch(compareProvider);

    return GestureDetector(
      onTap: () {
        if (imageState.currentImage == null) {
          ref.read(imageProvider.notifier).pickImage();
        }
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageState.currentImage == null)
                const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 48,
                        color: Colors.white70,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to select an image',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                )
              else
                Image.file(
                  isComparing ? imageState.originalImage! : imageState.currentImage!,
                  fit: BoxFit.cover,
                ),
              
              if (imageState.isProcessing)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              
              // Edge Detection Button
              if (imageState.currentImage != null)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.auto_graph,
                        color: Colors.white,
                      ),
                      tooltip: 'Detect Edges',
                      onPressed: () {
                        // Apply edge detection filter
                        final edgeDetectionFilter = Filter.getFilterByType(FilterType.edgeDetection);
                        ref.read(imageProvider.notifier).applyFilter(edgeDetectionFilter);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 