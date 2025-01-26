import 'package:flutter/material.dart';
import '../models/filter_parameter.dart';

class FilterParametersPanel extends StatelessWidget {
  final FilterConfig? filterConfig;
  final Function(String paramName, double value) onParameterChanged;

  const FilterParametersPanel({
    Key? key,
    required this.filterConfig,
    required this.onParameterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (filterConfig == null) {
      print('FilterConfig is null'); // Debug print
      return const SizedBox.shrink();
    }

    print('Building panel for ${filterConfig!.name}'); // Debug print
    print('Parameters: ${filterConfig!.parameters}'); // Debug print

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white, // Add background color
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: filterConfig!.parameters.map((param) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                param.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: param.currentValue,
                      min: param.minValue,
                      max: param.maxValue,
                      divisions: ((param.maxValue - param.minValue) / param.step).round(),
                      onChanged: (value) {
                        print('Slider changed: ${param.name} = $value'); // Debug print
                        param.currentValue = value;
                        onParameterChanged(param.name, value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      param.currentValue.toStringAsFixed(1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
} 