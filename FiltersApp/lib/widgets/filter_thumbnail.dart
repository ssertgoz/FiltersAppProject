import 'package:flutter/material.dart';

import '../models/filter.dart';

class FilterThumbnail extends StatelessWidget {
  final Filter filter;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterThumbnail({
    Key? key,
    required this.filter,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  IconData? get _filterIcon {
    switch (filter.type) {
      case FilterType.grayscale:
        return Icons.gradient;
      case FilterType.blur:
        return Icons.blur_on;
      case FilterType.sharpen:
        return Icons.shape_line;
      case FilterType.edgeDetection:
        return Icons.auto_graph;
      case FilterType.brightness:
        return Icons.brightness_6;
      case FilterType.contrast:
        return Icons.contrast;
      case FilterType.saturation:
        return Icons.palette;
      case FilterType.sepia:
        return Icons.filter_vintage;
      case FilterType.invert:
        return Icons.invert_colors;
      case FilterType.threshold:
        return Icons.tonality;
      case FilterType.original:
        return Icons.restart_alt;
      case FilterType.cloudEdgeDetection:
        return Icons.auto_graph;
      case FilterType.cloudBlur:
        return Icons.blur_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagePath;
    switch (filter.type) {
      case FilterType.original:
        imagePath = 'assets/images/original.png';
        break;
      case FilterType.grayscale:
        imagePath = 'assets/images/grayscale.png';
        break;
      case FilterType.blur:
        imagePath = 'assets/images/blur.png';
        break;
      case FilterType.sharpen:
        imagePath = 'assets/images/sharpen.png';
        break;
      case FilterType.edgeDetection:
        imagePath = 'assets/images/edge_detection.png';
        break;
      case FilterType.brightness:
        imagePath = 'assets/images/brightness.png';
        break;
      case FilterType.contrast:
        imagePath = 'assets/images/contrast.png';
        break;
      case FilterType.saturation:
        imagePath = 'assets/images/saturation.png';
        break;
      case FilterType.sepia:
        imagePath = 'assets/images/sepia.png';
        break;
      case FilterType.invert:
        imagePath = 'assets/images/invert.png';
        break;
      case FilterType.threshold:
        imagePath = 'assets/images/threshold.png';
        break;
      case FilterType.cloudEdgeDetection:
        imagePath = 'assets/images/edge_detection.png';
        break;
      case FilterType.cloudBlur:
        imagePath = 'assets/images/blur.png';
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SizedBox(
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.pink : Colors.transparent,
                    width: 2,
                  ),
                  color: Colors.grey[800],
                ),
                child: Icon(
                  _filterIcon,
                  color: isSelected ? Colors.pink : Colors.white70,
                  size: 30,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                filter.name,
                style: TextStyle(
                  color: isSelected ? Colors.pink : Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
