class FilterParameter {
  final String name;
  final double minValue;
  final double maxValue;
  final double defaultValue;
  final double step;
  double currentValue;

  FilterParameter({
    required this.name,
    required this.minValue,
    required this.maxValue,
    required this.defaultValue,
    this.step = 0.1,
  }) : currentValue = defaultValue;
}

class FilterConfig {
  final String name;
  final List<FilterParameter> parameters;

  FilterConfig({required this.name, required this.parameters});

  static final Map<String, FilterConfig> filters = {
    'Original': FilterConfig(
      name: 'Original',
      parameters: [], // No parameters needed
    ),
    'Brightness': FilterConfig(
      name: 'Brightness',
      parameters: [
        FilterParameter(
          name: 'Level',
          minValue: 0.0,
          maxValue: 2.0,
          defaultValue: 1.0,
        ),
      ],
    ),
    'Contrast': FilterConfig(
      name: 'Contrast',
      parameters: [
        FilterParameter(
          name: 'Level',
          minValue: 0.0,
          maxValue: 2.0,
          defaultValue: 1.0,
        ),
      ],
    ),
    'Saturation': FilterConfig(
      name: 'Saturation',
      parameters: [
        FilterParameter(
          name: 'Level',
          minValue: 0.0,
          maxValue: 2.0,
          defaultValue: 1.0,
        ),
      ],
    ),
    'Blur': FilterConfig(
      name: 'Blur',
      parameters: [
        FilterParameter(
          name: 'Sigma',
          minValue: 0.1,
          maxValue: 10.0,
          defaultValue: 3.0,
        ),
      ],
    ),
    'Sharpen': FilterConfig(
      name: 'Sharpen',
      parameters: [
        FilterParameter(
          name: 'Strength',
          minValue: 0.0,
          maxValue: 2.0,
          defaultValue: 0.5,
        ),
      ],
    ),
    'Grayscale': FilterConfig(
      name: 'Grayscale',
      parameters: [], // No adjustable parameters
    ),
    'Edge Detect': FilterConfig(
      name: 'Edge Detect',
      parameters: [], // No adjustable parameters
    ),
    'Sepia': FilterConfig(
      name: 'Sepia',
      parameters: [], // No adjustable parameters
    ),
    'Invert': FilterConfig(
      name: 'Invert',
      parameters: [], // No adjustable parameters
    ),
    'Threshold': FilterConfig(
      name: 'Threshold',
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
  };
} 