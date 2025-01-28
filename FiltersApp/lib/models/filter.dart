import '../models/filter_parameter.dart';

enum FilterType {
  original('Original'),
  grayscale('Grayscale'),
  blur('Blur'),
  sharpen('Sharpen'),
  edgeDetection('Edge Detect'),
  brightness('Brightness'),
  contrast('Contrast'),
  saturation('Saturation'),
  sepia('Sepia'),
  invert('Invert'),
  threshold('Threshold'),
  cloudEdgeDetection('Cloud Edge Detection'),
  cloudBlur('Cloud Blur');

  final String displayName;
  const FilterType(this.displayName);
}

class Filter {
  final FilterType type;
  final String name;
  double? intensity;

  Filter({
    required this.type,
    required this.name,
    this.intensity,
  });

  static Filter fromFilterConfig(String filterName, Map<String, double> parameters) {
    final type = _getFilterType(filterName);
    final config = FilterConfig.filters[filterName];
    final intensity = config?.parameters.isNotEmpty == true 
        ? config!.parameters.first.currentValue 
        : null;

    return Filter(
      type: type,
      name: filterName,
      intensity: intensity,
    );
  }

  static FilterType _getFilterType(String filterName) {
    switch (filterName.toLowerCase()) {
      case 'original':
        return FilterType.original;
      case 'grayscale':
        return FilterType.grayscale;
      case 'blur':
        return FilterType.blur;
      case 'sharpen':
        return FilterType.sharpen;
      case 'edge detect':
        return FilterType.edgeDetection;
      case 'brightness':
        return FilterType.brightness;
      case 'contrast':
        return FilterType.contrast;
      case 'saturation':
        return FilterType.saturation;
      case 'sepia':
        return FilterType.sepia;
      case 'invert':
        return FilterType.invert;
      case 'threshold':
        return FilterType.threshold;
      case 'cloud edge detection':
        return FilterType.cloudEdgeDetection;
      case 'cloud blur':
        return FilterType.cloudBlur;
      default:
        return FilterType.original;
    }
  }

  // Create filters from FilterConfig
  static List<Filter> get predefinedFilters {
    return FilterConfig.filters.entries.map((entry) {
      final config = entry.value;
      final type = _getFilterType(entry.key);
      final intensity = config.parameters.isNotEmpty 
          ? config.parameters.first.defaultValue 
          : null;

      return Filter(
        type: type,
        name: entry.key,
        intensity: intensity,
      );
    }).toList();
  }

  // Helper method to get filter by type
  static Filter getFilterByType(FilterType type) {
    return predefinedFilters.firstWhere(
      (filter) => filter.type == type,
      orElse: () => Filter(type: FilterType.original, name: type.displayName),
    );
  }
}
