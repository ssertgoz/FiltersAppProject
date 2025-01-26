import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/filter.dart';
import '../models/filter_parameter.dart';
import '../providers/filter_provider.dart';
import '../providers/selected_filter_provider.dart';
import '../providers/image_provider.dart';

// Add a provider to track slider visibility
final showSliderProvider = StateProvider<bool>((ref) => false);

class FilterList extends ConsumerWidget {
  const FilterList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(filterCategoryProvider);
    final currentFilters = ref.watch(filterProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);
    final showSlider = ref.watch(showSliderProvider);
    final filterConfig = FilterConfig.filters[selectedFilter.name];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show either categories or intensity slider
        SizedBox(
          height: 40,
          child: showSlider && filterConfig?.parameters.isNotEmpty == true
              ? _buildIntensitySlider(ref, filterConfig!, selectedFilter)
              : _buildCategories(ref, selectedCategory),
        ),
        const SizedBox(height: 8),
        // Filter thumbnails
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: currentFilters.map((filter) => 
              _buildFilterThumbnail(
                filter.name, 
                selectedFilter.name == filter.name,
                () {
                  // If already selected, toggle slider visibility
                  if (selectedFilter.name == filter.name) {
                    ref.read(showSliderProvider.notifier).state = 
                        !ref.read(showSliderProvider);
                  } else {
                    // If different filter selected, select it and show slider if it has parameters
                    ref.read(selectedFilterProvider.notifier).state = filter;
                    ref.read(showSliderProvider.notifier).state = 
                        FilterConfig.filters[filter.name]?.parameters.isNotEmpty == true;
                    ref.read(imageProvider.notifier).applyFilter(filter);
                  }
                }
              )
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(WidgetRef ref, FilterCategory selectedCategory) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildCategoryChip('BASIC', FilterCategory.basic == selectedCategory, () {
          ref.read(filterCategoryProvider.notifier).state = FilterCategory.basic;
        }),
        _buildCategoryChip('EFFECTS', FilterCategory.effects == selectedCategory, () {
          ref.read(filterCategoryProvider.notifier).state = FilterCategory.effects;
        }),
      ],
    );
  }

  Widget _buildIntensitySlider(WidgetRef ref, FilterConfig config, Filter selectedFilter) {
    final param = config.parameters.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Icon(Icons.tune, color: Colors.white70, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Slider(
              value: param.currentValue,
              min: param.minValue,
              max: param.maxValue,
              divisions: ((param.maxValue - param.minValue) / param.step).round(),
              activeColor: Colors.pink,
              inactiveColor: Colors.grey[800],
              onChanged: (value) {
                param.currentValue = value;
                final updatedFilter = Filter(
                  type: selectedFilter.type,
                  name: selectedFilter.name,
                  intensity: value,
                );
                ref.read(selectedFilterProvider.notifier).state = updatedFilter;
                ref.read(imageProvider.notifier).applyFilter(updatedFilter);
              },
            ),
          ),
          SizedBox(width: 8),
          Container(
            width: 40,
            child: Text(
              param.currentValue.toStringAsFixed(1),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterThumbnail(String name, bool isSelected, VoidCallback onTap) {
    IconData? filterIcon;
    
    // Assign icons based on filter name
    switch (name.toLowerCase()) {
      case 'grayscale':
        filterIcon = Icons.gradient;
        break;
      case 'blur':
        filterIcon = Icons.blur_on;
        break;
      case 'sharpen':
        filterIcon = Icons.shape_line;
        break;
      case 'edge detect':
        filterIcon = Icons.auto_graph;
        break;
      case 'brightness':
        filterIcon = Icons.brightness_6;
        break;
      case 'contrast':
        filterIcon = Icons.contrast;
        break;
      case 'saturation':
        filterIcon = Icons.palette;
        break;
      case 'sepia':
        filterIcon = Icons.filter_vintage;
        break;
      case 'invert':
        filterIcon = Icons.invert_colors;
        break;
      case 'threshold':
        filterIcon = Icons.tonality;
        break;
      case 'original':
        filterIcon = Icons.restart_alt;
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
                  filterIcon,
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
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
          ),
          backgroundColor: isSelected ? Colors.pink : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
} 