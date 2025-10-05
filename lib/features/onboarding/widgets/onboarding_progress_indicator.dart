import 'package:flutter/material.dart';

import '../../../core/theming/colors.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final Color activeColor;

  const OnboardingProgressIndicator({
    Key? key,
    required this.currentIndex,
    required this.totalPages,
    required this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          totalPages,
              (index) => _buildIndicatorDot(index),
        ),
      ),
    );
  }

  Widget _buildIndicatorDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: currentIndex == index ? 32 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? activeColor
            : activeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}