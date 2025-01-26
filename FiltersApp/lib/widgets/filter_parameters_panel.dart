import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/filter.dart';
import '../models/filter_parameter.dart';
import '../providers/selected_filter_provider.dart';
import '../providers/image_provider.dart';

class FilterParametersPanel extends ConsumerStatefulWidget {
  final FilterConfig? filterConfig;

  const FilterParametersPanel({
    Key? key,
    required this.filterConfig,
  }) : super(key: key);

  @override
  ConsumerState<FilterParametersPanel> createState() => _FilterParametersPanelState();
}

class _FilterParametersPanelState extends ConsumerState<FilterParametersPanel> {
  Timer? _debounceTimer;
  Map<String, double> _pendingValues = {};

  void _onSliderChanged(FilterParameter param, double value) {
    // Update both the pending value and the parameter's current value
    setState(() {
      _pendingValues[param.name] = value;
      param.currentValue = value;
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      final latestValue = _pendingValues[param.name];
      if (latestValue != null) {
        // Update the filter state
        ref.read(selectedFilterProvider.notifier).updateParameter(param.name, latestValue);
        
        // Get the current filter and update it with the new intensity
        final currentFilter = ref.read(selectedFilterProvider);
        final updatedFilter = Filter(
          type: currentFilter.type,
          name: currentFilter.name,
          intensity: latestValue,
        );
        
        // Apply the filter
        ref.read(imageProvider.notifier).applyFilter(updatedFilter, isNewFilter: false);
        _pendingValues.remove(param.name);
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
      print('FilterConfig is null'); // Debug print
      return const SizedBox.shrink();
    }

    print('Building panel for ${widget.filterConfig!.name}'); // Debug print
    print('Parameters: ${widget.filterConfig!.parameters}'); // Debug print

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.filterConfig!.parameters.map((param) {
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
                    onChanged: (value) => _onSliderChanged(param, value),
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
        }).toList(),
      ),
    );
  }
}
