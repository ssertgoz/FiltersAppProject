import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/filter.dart';

enum FilterCategory {
  basic,
  effects,
  cloud
}

final filterCategoryProvider = StateProvider<FilterCategory>((ref) => FilterCategory.basic);

final filterProvider = Provider<List<Filter>>((ref) {
  final selectedCategory = ref.watch(filterCategoryProvider);

  final filtersByCategory = {
    FilterCategory.basic: [
      Filter(type: FilterType.original, name: FilterType.original.displayName),
      Filter(type: FilterType.brightness, name: FilterType.brightness.displayName),
      Filter(type: FilterType.contrast, name: FilterType.contrast.displayName),
      Filter(type: FilterType.saturation, name: FilterType.saturation.displayName),
      Filter(type: FilterType.blur, name: FilterType.blur.displayName),
      Filter(type: FilterType.sharpen, name: FilterType.sharpen.displayName),
    ],
    FilterCategory.effects: [
      Filter(type: FilterType.grayscale, name: FilterType.grayscale.displayName),
      Filter(type: FilterType.edgeDetection, name: FilterType.edgeDetection.displayName),
      Filter(type: FilterType.sepia, name: FilterType.sepia.displayName),
      Filter(type: FilterType.invert, name: FilterType.invert.displayName),
      Filter(type: FilterType.threshold, name: FilterType.threshold.displayName),
    ],
    FilterCategory.cloud: [
      Filter(
        type: FilterType.cloudEdgeDetection,
        name: FilterType.cloudEdgeDetection.displayName,
      ),
      Filter(
        type: FilterType.cloudBlur,
        name: FilterType.cloudBlur.displayName,
      ),
    ],
  };

  return filtersByCategory[selectedCategory] ?? [];
}); 