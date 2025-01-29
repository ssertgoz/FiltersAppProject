import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/compare_provider.dart';
import '../providers/image_provider.dart';
import '../widgets/filter_list.dart';
import '../widgets/image_editor.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasImage = ref.watch(imageProvider).currentImage != null;
    final imageState = ref.watch(imageProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.white),
          onPressed: () {
            if (hasImage) {
              ref.read(imageProvider.notifier).clearImage();
            }
          },
        ),
        actions: [
          if (!hasImage)
            IconButton(
              icon:
                  const Icon(Icons.add_photo_alternate, color: AppColors.white),
              onPressed: () => ref.read(imageProvider.notifier).pickImage(),
            ),
          if (hasImage)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: imageState.hasFilteredImage
                  ? () async {
                      final success = await ref
                          .read(imageProvider.notifier)
                          .saveToGallery();
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(AppStrings.imageSavedToGallery),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(AppStrings.errorSavingToGallery),
                          ),
                        );
                      }
                    }
                  : null,
            ),
        ],
        title: const Text(
          AppStrings.filtersTitle,
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          const Expanded(
            child: ImageEditor(),
          ),
          Container(
            color: AppColors.black,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.undo),
                      onPressed:
                          imageState.hasFilteredImage && imageState.canUndo
                              ? () => ref.read(imageProvider.notifier).undo()
                              : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.compare_arrows),
                      onPressed: hasImage
                          ? () {
                              final isComparing = ref.read(compareProvider);
                              ref.read(compareProvider.notifier).state =
                                  !isComparing;
                            }
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.redo),
                      onPressed:
                          imageState.hasFilteredImage && imageState.canRedo
                              ? () => ref.read(imageProvider.notifier).redo()
                              : null,
                    ),
                  ],
                ),
                if (hasImage) const FilterList(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
