import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/filter_constants.dart';
import '../models/filter.dart';

final filterCategoryProvider =
    StateProvider<FilterCategory>((ref) => FilterCategory.basic);

final filterProvider = Provider<List<Filter>>((ref) {
  final selectedCategory = ref.watch(filterCategoryProvider);
  return FilterConstants.filtersByCategory[selectedCategory] ?? [];
});
