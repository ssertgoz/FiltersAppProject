import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/filter_constants.dart';
import '../providers/filter_provider.dart';
import 'category_chip.dart';

class FilterCategories extends ConsumerWidget {
  final FilterCategory selectedCategory;

  const FilterCategories({
    Key? key,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CategoryChip(
            label: 'BASIC',
            isSelected: FilterCategory.basic == selectedCategory,
            onTap: () {
              ref.read(filterCategoryProvider.notifier).state =
                  FilterCategory.basic;
            },
          ),
          CategoryChip(
            label: 'EFFECTS',
            isSelected: FilterCategory.effects == selectedCategory,
            onTap: () {
              ref.read(filterCategoryProvider.notifier).state =
                  FilterCategory.effects;
            },
          ),
          CategoryChip(
            label: 'CLOUD',
            isSelected: FilterCategory.cloud == selectedCategory,
            onTap: () {
              ref.read(filterCategoryProvider.notifier).state =
                  FilterCategory.cloud;
            },
          ),
        ],
      ),
    );
  }
}
