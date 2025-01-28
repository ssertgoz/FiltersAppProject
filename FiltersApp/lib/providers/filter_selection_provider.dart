import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/filter.dart';
import '../models/filter_parameter.dart';
import '../providers/image_provider.dart';
import '../providers/selected_filter_provider.dart';

final showSliderProvider = StateProvider<bool>((ref) => false);

class FilterSelectionNotifier extends StateNotifier<void> {
  final Ref ref;

  FilterSelectionNotifier(this.ref) : super(null);

  void handleFilterSelection(Filter filter) {
    final selectedFilter = ref.read(selectedFilterProvider);

    // If already selected, toggle slider visibility
    if (selectedFilter.name == filter.name) {
      ref.read(showSliderProvider.notifier).state =
          !ref.read(showSliderProvider);
    } else {
      // Special handling for Original filter
      if (filter.name.toLowerCase() == 'original') {
        ref.read(imageProvider.notifier).clearHistory();
        // Reset selected filter and hide slider
        ref.read(selectedFilterProvider.notifier).updateFilter(filter);
        ref.read(showSliderProvider.notifier).state = false;
      } else {
        // If different filter selected, select it and show slider if it has parameters
        ref.read(selectedFilterProvider.notifier).updateFilter(filter);
        ref.read(showSliderProvider.notifier).state =
            FilterConfig.filters[filter.name]?.parameters.isNotEmpty == true;
        ref.read(imageProvider.notifier).applyFilter(filter, isNewFilter: true);
      }
    }
  }
}

final filterSelectionProvider =
    StateNotifierProvider<FilterSelectionNotifier, void>((ref) {
  return FilterSelectionNotifier(ref);
});
