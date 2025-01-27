import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/filter.dart';
import '../models/filter_parameter.dart';
import '../providers/image_provider.dart';
import '../providers/selected_filter_provider.dart';

class FilterParametersPanel extends ConsumerStatefulWidget {
  final FilterConfig? filterConfig;

  const FilterParametersPanel({
    Key? key,
    required this.filterConfig,
  }) : super(key: key);

  @override
  ConsumerState<FilterParametersPanel> createState() =>
      _FilterParametersPanelState();
}

class _FilterParametersPanelState extends ConsumerState<FilterParametersPanel> {
  Timer? _debounceTimer;
  Map<String, double> pendingValues = {};

  void _onSliderChanged(FilterParameter param, double value) {
    // Update both the pending value and the parameter's current value
    setState(() {
      pendingValues[param.name] = value;
      param.currentValue = value;
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      final latestValue = pendingValues[param.name];
      if (latestValue != null) {
        // Update the filter state
        ref
            .read(selectedFilterProvider.notifier)
            .updateParameter(param.name, latestValue);

        // Get the current filter and update it with the new intensity
        final currentFilter = ref.read(selectedFilterProvider);
        final updatedFilter = Filter(
          type: currentFilter.type,
          name: currentFilter.name,
          intensity: latestValue,
        );

        // Apply the filter
        ref
            .read(imageProvider.notifier)
            .applyFilter(updatedFilter, isNewFilter: false);
        pendingValues.remove(param.name);
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filterConfig == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.filterConfig!.parameters.map((param) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              spacing: 8,
              children: [
                const Icon(Icons.tune, color: Colors.white70, size: 20),
                Expanded(
                  child: Slider(
                    value: param.currentValue,
                    min: param.minValue,
                    max: param.maxValue,
                    divisions: ((param.maxValue - param.minValue) / param.step)
                        .round(),
                    activeColor: Colors.pink,
                    inactiveColor: Colors.grey[800],
                    onChanged: (value) => _onSliderChanged(param, value),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    param.currentValue.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
