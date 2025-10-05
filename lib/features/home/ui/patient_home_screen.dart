import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/ui/widgets/actions/quick_actions_section.dart';
import 'package:tabiby/features/home/ui/widgets/appointments/appointments_section.dart';
import 'package:tabiby/features/home/ui/widgets/common/animated_screen.dart';
import 'package:tabiby/features/home/ui/widgets/header/user_header.dart';
import 'package:tabiby/features/home/ui/widgets/health/health_overview_section.dart';
import 'package:tabiby/features/home/ui/widgets/medications/medications_section.dart';
import 'package:tabiby/features/home/ui/widgets/navigation/bottom_navigation_bar.dart';
import 'package:tabiby/features/home/ui/widgets/reports/reports_section.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedScreen(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                UserHeader(),
                HealthOverviewSection(),
                QuickActionsSection(),
                AppointmentsSection(),
                ReportsSection(),
                MedicationsSection(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}