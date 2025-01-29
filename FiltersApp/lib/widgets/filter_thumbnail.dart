import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
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
                    color: isSelected
                        ? AppColors.selectedBorder
                        : AppColors.unselectedBorder,
                    width: 2,
                  ),
                  color: AppColors.grey800,
                ),
                child: Icon(
                  _filterIcon,
                  color: isSelected
                      ? AppColors.selectedIcon
                      : AppColors.unselectedIcon,
                  size: 30,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                filter.name,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.selectedText
                      : AppColors.unselectedText,
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
