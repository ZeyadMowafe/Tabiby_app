import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isTablet;
  final bool isSmallScreen;

  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.isTablet,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo Section
        Container(
          width: isTablet ? 120 : 100,
          height: isTablet ? 120 : 100,
          margin: EdgeInsets.only(top: isSmallScreen ? 20 : 40),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlue, AppColors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Icon(
            Icons.medical_services_rounded,
            color: Colors.white,
            size: isTablet ? 60 : 50,
          ),
        ),

        SizedBox(height: isSmallScreen ? 24 : 32),

        // Welcome Text
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 32 : 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.8,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          subtitle,
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
