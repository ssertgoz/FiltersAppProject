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
                      icon: const Icon(Icons.rotate_left, color: Colors.white),
                      onPressed: hasImage ? () {} : null,
                    ),
                    GestureDetector(
                      onTapDown: hasImage 
                          ? (_) => ref.read(compareProvider.notifier).state = true
                          : null,
                      onTapUp: hasImage 
                          ? (_) => ref.read(compareProvider.notifier).state = false
                          : null,
                      onTapCancel: hasImage 
                          ? () => ref.read(compareProvider.notifier).state = false
                          : null,
                      child: IconButton(
                        icon: const Icon(Icons.compare, color: Colors.white),
                        onPressed: null, // We're using GestureDetector instead
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.rotate_right, color: Colors.white),
                      onPressed: hasImage ? () {} : null,
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
