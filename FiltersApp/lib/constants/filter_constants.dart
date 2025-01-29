import '../../models/filter.dart';
import '../../models/filter_config.dart';
import '../../models/filter_parameter.dart';

enum FilterCategory { basic, effects, cloud }

class FilterConstants {
  static final Map<FilterCategory, List<Filter>> filtersByCategory = {
    FilterCategory.basic: [
      Filter(type: FilterType.original, name: FilterType.original.displayName),
      Filter(
          type: FilterType.brightness, name: FilterType.brightness.displayName),
      Filter(type: FilterType.contrast, name: FilterType.contrast.displayName),
      Filter(
          type: FilterType.saturation, name: FilterType.saturation.displayName),
      Filter(type: FilterType.blur, name: FilterType.blur.displayName),
      Filter(type: FilterType.sharpen, name: FilterType.sharpen.displayName),
    ],
    FilterCategory.effects: [
      Filter(
          type: FilterType.grayscale, name: FilterType.grayscale.displayName),
      Filter(
          type: FilterType.edgeDetection,
          name: FilterType.edgeDetection.displayName),
      Filter(type: FilterType.sepia, name: FilterType.sepia.displayName),
      Filter(type: FilterType.invert, name: FilterType.invert.displayName),
      Filter(
          type: FilterType.threshold, name: FilterType.threshold.displayName),
    ],
    FilterCategory.cloud: [
      Filter(
        type: FilterType.cloudEdgeDetection,
        name: FilterType.cloudEdgeDetection.displayName,
      ),
      Filter(
        type: FilterType.cloudBlur,
        name: FilterType.cloudBlur.displayName,
      ),
    ],
  };

  static final Map<FilterType, FilterConfig> filters = {
    FilterType.original: FilterConfig(
      name: FilterType.original.displayName,
      parameters: [], // No parameters needed
    ),
    FilterType.brightness: FilterConfig(
      name: FilterType.brightness.displayName,
      parameters: [
        FilterParameter(
          name: 'Level',
          minValue: 0.0,
          maxValue: 2.0,
          defaultValue: 1.0,
        ),
      ],
    ),
    FilterType.contrast: FilterConfig(
      name: FilterType.contrast.displayName,
      parameters: [
        FilterParameter(
          name: 'Level',
          minValue: 0.0,
          maxValue: 2.0,
          defaultValue: 1.0,
        ),
      ],
    ),
    FilterType.saturation: FilterConfig(
      name: FilterType.saturation.displayName,
      parameters: [
        FilterParameter(
          name: 'Level',
          minValue: 0.0,
          maxValue: 2.0,
          defaultValue: 1.0,
        ),
      ],
    ),
    FilterType.blur: FilterConfig(
      name: FilterType.blur.displayName,
      parameters: [
        FilterParameter(
          name: 'Sigma',
          minValue: 0.1,
          maxValue: 10.0,
          defaultValue: 3.0,
        ),
      ],
    ),
    FilterType.sharpen: FilterConfig(
      name: FilterType.sharpen.displayName,
      parameters: [
        FilterParameter(
          name: 'Strength',
          minValue: 0.0,
          maxValue: 2.0,
          defaultValue: 0.5,
        ),
      ],
    ),
    FilterType.grayscale: FilterConfig(
      name: FilterType.grayscale.displayName,
      parameters: [], // No adjustable parameters
    ),
    FilterType.edgeDetection: FilterConfig(
      name: FilterType.edgeDetection.displayName,
      parameters: [], // No adjustable parameters
    ),
    FilterType.sepia: FilterConfig(
      name: FilterType.sepia.displayName,
      parameters: [], // No adjustable parameters
    ),
    FilterType.invert: FilterConfig(
      name: FilterType.invert.displayName,
      parameters: [], // No adjustable parameters
    ),
    FilterType.threshold: FilterConfig(
      name: FilterType.threshold.displayName,
      parameters: [
        FilterParameter(
          name: 'Level',
          minValue: 0.0,
          maxValue: 255.0,
          defaultValue: 127.0,
          step: 1.0,
        ),
      ],
    ),
    FilterType.cloudEdgeDetection: FilterConfig(
      name: FilterType.cloudEdgeDetection.displayName,
      parameters: [], // Cloud filters don't have parameters yet
    ),
    FilterType.cloudBlur: FilterConfig(
      name: FilterType.cloudBlur.displayName,
      parameters: [], // Cloud filters don't have parameters yet
    ),
  };
}
