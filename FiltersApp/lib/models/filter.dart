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
}
