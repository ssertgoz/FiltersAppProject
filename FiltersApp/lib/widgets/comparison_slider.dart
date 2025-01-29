import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ComparisonSlider extends StatefulWidget {
  final File beforeImage;
  final File afterImage;
  final bool isComparing;

  const ComparisonSlider({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    this.isComparing = true,
  });

  @override
  State<ComparisonSlider> createState() => _ComparisonSliderState();
}

class _ComparisonSliderState extends State<ComparisonSlider> {
  double _sliderPosition = 0.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          children: [
            // Base layer: Filtered image (full width)
            SizedBox(
              width: width,
              height: height,
              child: Image.file(
                widget.afterImage,
                fit: BoxFit.cover,
              ),
            ),

            // Middle layer: Original image with clip
            if (widget.isComparing)
              ClipRect(
                clipper: _ImageClipper(_sliderPosition),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Image.file(
                    widget.beforeImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            if (widget.isComparing) ...[
              // Slider line
              Positioned(
                left: width * _sliderPosition - 1,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: AppColors.white,
                ),
              ),

              // Slider handle
              Positioned(
                left: width * _sliderPosition - 16,
                top: (height - 32) / 2,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _sliderPosition =
                          (_sliderPosition + details.delta.dx / width)
                              .clamp(0.0, 1.0);
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black87.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.compare_arrows,
                      color: AppColors.black87,
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Touch area
              Positioned.fill(
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _sliderPosition =
                          (_sliderPosition + details.delta.dx / width)
                              .clamp(0.0, 1.0);
                    });
                  },
                  onTapDown: (details) {
                    setState(() {
                      _sliderPosition =
                          (details.localPosition.dx / width).clamp(0.0, 1.0);
                    });
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ImageClipper extends CustomClipper<Rect> {
  final double position;

  _ImageClipper(this.position);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * position, size.height);
  }

  @override
  bool shouldReclip(_ImageClipper oldClipper) {
    return position != oldClipper.position;
  }
}
