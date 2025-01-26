import 'package:flutter/material.dart';

class FilterThumbnail extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterThumbnail({
    Key? key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  IconData? get _filterIcon {
    switch (name.toLowerCase()) {
      case 'grayscale':
        return Icons.gradient;
      case 'blur':
        return Icons.blur_on;
      case 'sharpen':
        return Icons.shape_line;
      case 'edge detect':
        return Icons.auto_graph;
      case 'brightness':
        return Icons.brightness_6;
      case 'contrast':
        return Icons.contrast;
      case 'saturation':
        return Icons.palette;
      case 'sepia':
        return Icons.filter_vintage;
      case 'invert':
        return Icons.invert_colors;
      case 'threshold':
        return Icons.tonality;
      case 'original':
        return Icons.restart_alt;
      default:
        return Icons.filter;
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
                name,
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
