import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final Color activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;
  final double? dotHeight;
  final double? activeDotWidth;
  final double? inactiveDotWidth;
  final double? dotSpacing;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const OnboardingProgressIndicator({
    Key? key,
    required this.currentIndex,
    required this.totalPages,
    required this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
    this.dotHeight,
    this.activeDotWidth,
    this.inactiveDotWidth,
    this.dotSpacing,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(16.r),
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
    final bool isActive = currentIndex == index;
    final double height = dotHeight ?? 6.h;
    final double width = isActive 
        ? (activeDotWidth ?? 32.w) 
        : (inactiveDotWidth ?? 6.w);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: dotSpacing ?? 4.w),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isActive
            ? activeColor
            : (inactiveColor ?? activeColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}