import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/ui/widgets/bottom_navigation_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiaryText.withOpacity(0.1),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            BottomNavigationItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isActive: true,
            ),
            BottomNavigationItem(
              icon: Icons.calendar_month_rounded,
              label: 'Appointments',
              isActive: false,
            ),
            BottomNavigationItem(
              icon: Icons.medical_services_rounded,
              label: 'Services',
              isActive: false,
            ),
            BottomNavigationItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              isActive: false,
            ),
          ],
        ),
      ),
    );
  }
}
