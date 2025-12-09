import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';
import 'package:tabiby/features/home/ui/widgets/advertisement.dart';
import 'package:tabiby/features/home/ui/widgets/booking_page.dart';
import 'package:tabiby/features/home/ui/widgets/doctors_pages.dart';
import 'package:tabiby/features/home/ui/widgets/home_header_screen.dart';
import 'package:tabiby/features/home/ui/widgets/minimal_doctor_card.dart';
import 'package:tabiby/features/home/ui/widgets/profile_page.dart';
import 'package:tabiby/features/home/ui/widgets/search_bar.dart';
import 'package:tabiby/features/home/ui/widgets/specialties_full_screen.dart';
import 'package:tabiby/features/home/ui/widgets/specialties_selection.dart';
import 'package:tabiby/features/home/ui/widgets/unified_section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // إضافة function لتغيير الـ tab
  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            HomeContent(),
            SpecialtiesFullScreen(),
            DoctorsPage(),
            BookingsPage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: ColorsManager.white,
            boxShadow: [
              BoxShadow(
                color: ColorsManager.lighterGray,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: ColorsManager.white,
            selectedItemColor: ColorsManager.primaryColor,
            unselectedItemColor: ColorsManager.lightGray,
            selectedLabelStyle: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(fontSize: 11.sp),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Icon(Icons.home_outlined, size: 24.sp),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Icon(Icons.home, size: 24.sp),
                ),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Icon(Icons.medical_services_outlined, size: 24.sp),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Icon(Icons.medical_services, size: 24.sp),
                ),
                label: 'التخصصات',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Icon(Icons.local_hospital_outlined, size: 24.sp),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Icon(Icons.local_hospital, size: 24.sp),
                ),
                label: 'الدكاترة',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Icon(Icons.calendar_today_outlined, size: 24.sp),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Icon(Icons.calendar_today, size: 24.sp),
                ),
                label: 'حجوزاتي',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Icon(Icons.person_outline, size: 24.sp),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Icon(Icons.person, size: 24.sp),
                ),
                label: 'حسابي',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsManager.backgroundGray,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with subtle gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorsManager.white,
                      ColorsManager.moreLighterGray,
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeaderScreen(),
                      Gap(24.h),
                      SearchBarScreen(),
                      Gap(24.h),
                      Advertisement(),
                    ],
                  ),
                ),
              ),

              // Info Banner - Subtle and Professional
              SpecialtiesSelection(
                onViewAllPressed: () {
                  // ابحث عن الـ HomeScreenState واستدعي changeTab
                  final homeState =
                      context.findAncestorStateOfType<_HomeScreenState>();
                  homeState?.changeTab(1); // index 1 = التخصصات
                },
              ),

              Gap(32.h),

              // Top Rated Doctors
              UnifiedSectionHeader(
                subtitle: "اختيار دقيق من أفضل الأطباء",
                title: 'أفضل الدكاترة',
                showButton: true,
                onPressed: () {
                  final homeState =
                      context.findAncestorStateOfType<_HomeScreenState>();
                  homeState?.changeTab(2);
                },
              ),

              Gap(16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    MinimalDoctorCard(
                      name: 'د. محمد أحمد السيد',
                      specialty: 'استشاري أمراض القلب والأوعية الدموية',
                      rating: '4.9',
                      patients: '250',
                      price: '150 جنيه',
                      icon: Icons.favorite_outline,
                    ),
                    Gap(12.h),
                    MinimalDoctorCard(
                      name: 'د. سارة علي محمود',
                      specialty: 'استشاري طب وجراحة الأسنان',
                      rating: '4.8',
                      patients: '180',
                      price: '120 جنيه',
                      icon: Icons.medical_services_outlined,
                    ),
                    Gap(12.h),
                    MinimalDoctorCard(
                      name: 'د. خالد حسن عبدالله',
                      specialty: 'استشاري جراحة العظام والمفاصل',
                      rating: '4.9',
                      patients: '220',
                      price: '180 جنيه',
                      icon: Icons.accessibility_new_outlined,
                    ),
                    Gap(12.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




