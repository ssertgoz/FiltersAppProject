import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/image_provider.dart';
import '../providers/compare_provider.dart';
import '../widgets/filter_list.dart';
import '../widgets/image_editor.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasImage = ref.watch(imageProvider).currentImage != null;
    final imageState = ref.watch(imageProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            if (hasImage) {
              ref.read(imageProvider.notifier).clearImage();
            }
          },
        ),
        actions: [
          if (!hasImage)
            IconButton(
              icon: const Icon(Icons.add_photo_alternate, color: Colors.white),
              onPressed: () => ref.read(imageProvider.notifier).pickImage(),
            ),
          if (hasImage)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: () {
                // TODO: Implement save functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Save functionality will be implemented soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
        title: const Text(
          'Filters',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const Expanded(
            child: ImageEditor(),
          ),
          Container(
            color: Colors.black,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.undo,
                        color: hasImage ? Colors.white : Colors.white38,
                      ),
                      onPressed: hasImage && imageState.canUndo
                          ? () => ref.read(imageProvider.notifier).undo()
                          : null,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.compare_arrows,
                        color: hasImage ? Colors.white : Colors.white38,
                      ),
                      onPressed: hasImage
                          ? () {
                              final isComparing = ref.read(compareProvider);
                              ref.read(compareProvider.notifier).state = !isComparing;
                            }
                          : null,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.redo,
                        color: hasImage ? Colors.white : Colors.white38,
                      ),
                      onPressed: hasImage && imageState.canRedo
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
