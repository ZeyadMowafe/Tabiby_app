import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GradientIconContainer extends StatelessWidget {
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final double size;
  final double iconSize;
  
  const GradientIconContainer({
    super.key,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    this.size = 48,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: iconSize,
      ),
    );
  }
}
