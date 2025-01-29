import 'package:filters_app/constants/filter_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/filter.dart';
import '../providers/image_provider.dart';
import '../providers/selected_filter_provider.dart';

final showSliderProvider = StateProvider<bool>((ref) => false);

class FilterSelectionNotifier extends StateNotifier<void> {
  final Ref ref;

  FilterSelectionNotifier(this.ref) : super(null);

  void handleFilterSelection(Filter filter) {
    final selectedFilter = ref.read(selectedFilterProvider);

    if (selectedFilter.type == filter.type) {
      ref.read(showSliderProvider.notifier).state =
          !ref.read(showSliderProvider);
    } else {
      if (filter.type == FilterType.original) {
        ref.read(imageProvider.notifier).clearHistory();
        ref.read(selectedFilterProvider.notifier).updateFilter(filter);
        ref.read(showSliderProvider.notifier).state = false;
      } else {
        ref.read(selectedFilterProvider.notifier).updateFilter(filter);
        ref.read(showSliderProvider.notifier).state =
            FilterConstants.filters[filter.type]?.parameters.isNotEmpty == true;
        ref.read(imageProvider.notifier).applyFilter(filter, isNewFilter: true);
      }
    }
  }
}

final filterSelectionProvider =
    StateNotifierProvider<FilterSelectionNotifier, void>((ref) {
  return FilterSelectionNotifier(ref);
});
