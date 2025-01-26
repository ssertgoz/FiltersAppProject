import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/filter.dart';

enum FilterCategory {
  basic,
  effects,
}

final filterCategoryProvider = StateProvider<FilterCategory>((ref) => FilterCategory.basic);

final filterProvider = Provider<List<Filter>>((ref) {
  final selectedCategory = ref.watch(filterCategoryProvider);

  final filtersByCategory = {
    FilterCategory.basic: [
      Filter.getFilterByType(FilterType.original),
      Filter.getFilterByType(FilterType.brightness),
      Filter.getFilterByType(FilterType.contrast),
      Filter.getFilterByType(FilterType.saturation),
      Filter.getFilterByType(FilterType.blur),
      Filter.getFilterByType(FilterType.sharpen),
    ],
    FilterCategory.effects: [
      Filter.getFilterByType(FilterType.grayscale),
      Filter.getFilterByType(FilterType.edgeDetection),
      Filter.getFilterByType(FilterType.sepia),
      Filter.getFilterByType(FilterType.invert),
      Filter.getFilterByType(FilterType.threshold),
    ],
  };

  return filtersByCategory[selectedCategory] ?? [];
}); 