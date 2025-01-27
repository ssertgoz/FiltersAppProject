import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/compare_provider.dart';
import '../providers/image_provider.dart';
import 'comparison_slider.dart';

class ImageEditor extends ConsumerWidget {
  const ImageEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageProvider);
    final isComparing = ref.watch(compareProvider);

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: isComparing
                            ? ComparisonSlider(
                                beforeImage: imageState.originalImage!,
                                afterImage: imageState.currentImage!,
                                isComparing: isComparing,
                              )
                            : Image.file(
                                imageState.currentImage!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    if (imageState.isProcessing)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (imageState.currentImage != null)
          Container(
            color: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // History timeline
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: imageState.history.length + 1,
                    itemBuilder: (context, index) {
                      final isOriginal = index == 0;
                      final isSelected =
                          index - 1 == imageState.currentStepIndex;

                      return GestureDetector(
                        onTap: () {
                          if (isOriginal) {
                            ref.read(imageProvider.notifier).clearHistory();
                          } else {
                            ref
                                .read(imageProvider.notifier)
                                .goToStep(index - 1);
                          }
                        },
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isSelected ? Colors.pink : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.file(
                                          isOriginal
                                              ? imageState.originalImage!
                                              : imageState
                                                  .history[index - 1].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isOriginal
                                        ? 'Original'
                                        : imageState
                                            .history[index - 1].filter.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              if (isSelected && !isOriginal)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(imageProvider.notifier)
                                          .deleteFilter(index - 1);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.pink,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
