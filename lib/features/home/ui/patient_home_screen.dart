import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabiby/core/theming/colors.dart';


import 'package:tabiby/features/home/ui/widgets/common/animated_screen.dart';
import 'package:tabiby/features/home/ui/widgets/header/user_header.dart';
import 'package:tabiby/features/home/ui/widgets/navigation/bottom_navigation_bar.dart';
import 'package:tabiby/features/home/ui/widgets/search/search_bar.dart';


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
              children: [
                 UserHeader(),
                SearchBarWidget(),
            
               
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}