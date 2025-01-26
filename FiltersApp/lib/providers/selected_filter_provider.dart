import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/filter.dart';
import '../models/filter_parameter.dart';

final selectedFilterProvider = StateProvider<Filter>((ref) {
  // Create a default filter instead of trying to get from predefinedFilters
  return Filter(
    type: FilterType.original,
    name: FilterType.original.displayName,
  );
}); 