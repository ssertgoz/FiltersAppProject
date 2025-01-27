import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/filter_parameter.dart';
import '../providers/filter_provider.dart';
import '../providers/image_provider.dart';
import '../providers/selected_filter_provider.dart';
import 'filter_categories.dart';
import 'filter_parameters_panel.dart';
import 'filter_thumbnail.dart';

// Add a provider to track slider visibility
final showSliderProvider = StateProvider<bool>((ref) => false);

class FilterList extends ConsumerWidget {
  const FilterList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(selectedFilterProvider);
    final selectedCategory = ref.watch(filterCategoryProvider);
    final currentFilters = ref.watch(filterProvider);
    final showSlider = ref.watch(showSliderProvider);
    final filterConfig = FilterConfig.filters[selectedFilter.name];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 80,
          child: showSlider && filterConfig?.parameters.isNotEmpty == true
              ? FilterParametersPanel(filterConfig: filterConfig)
              : FilterCategories(selectedCategory: selectedCategory),
        ),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: currentFilters.map((filter) {
              return FilterThumbnail(
                filter: filter,
                isSelected: selectedFilter.name == filter.name,
                onTap: () {
                  // If already selected, toggle slider visibility
                  if (selectedFilter.name == filter.name) {
                    ref.read(showSliderProvider.notifier).state =
                        !ref.read(showSliderProvider);
                  } else {
                    // Special handling for Original filter
                    if (filter.name.toLowerCase() == 'original') {
                      ref.read(imageProvider.notifier).clearHistory();
                    } else {
                      // If different filter selected, select it and show slider if it has parameters
                      ref
                          .read(selectedFilterProvider.notifier)
                          .updateFilter(filter);
                      ref.read(showSliderProvider.notifier).state = FilterConfig
                              .filters[filter.name]?.parameters.isNotEmpty ==
                          true;
                      ref
                          .read(imageProvider.notifier)
                          .applyFilter(filter, isNewFilter: true);
                    }
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
