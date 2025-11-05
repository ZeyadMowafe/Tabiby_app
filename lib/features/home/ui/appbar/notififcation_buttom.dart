import 'package:flutter/material.dart';
import 'package:tabiby/core/theming/colors.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        Positioned(
          right: 12,
          top: 12,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.notificationDot,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.notificationDot.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}