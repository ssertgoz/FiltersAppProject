import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/filter.dart';
import '../models/filter_parameter.dart';

class SelectedFilterNotifier extends StateNotifier<Filter> {
  SelectedFilterNotifier() : super(Filter(
    type: FilterType.original,
    name: FilterType.original.displayName,
  ));

  void updateFilter(Filter filter) {
    state = filter;
  }

  void updateParameter(String paramName, double value) {
    state = Filter(
      type: state.type,
      name: state.name,
      intensity: value,
    );
  }
}

final selectedFilterProvider = StateNotifierProvider<SelectedFilterNotifier, Filter>((ref) {
  return SelectedFilterNotifier();
});