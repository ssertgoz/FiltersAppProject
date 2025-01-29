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
