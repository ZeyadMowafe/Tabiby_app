// lib/features/home/ui/patient_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // أضف هذا
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/logic/home_cubit.dart'; // أضف الـ Cubit
import 'package:tabiby/features/home/logic/home_state.dart'; // أضف الـ State
import 'package:tabiby/features/home/ui/select_doctor/top_doctors_section.dart';
import 'package:tabiby/features/home/ui/appbar/home_app_bar.dart';
import 'package:tabiby/features/home/ui/searchbar/search_bar.dart';
import 'package:tabiby/features/home/ui/upcoming_appointment/upcoming_appointments_section.dart';
import 'widgets/common/animated_screen.dart';

import 'specialties/specialties_section.dart';
import 'clinics/clinics_section.dart';
import 'booking/recent_bookings_section.dart';
import 'bottom_navigation/bottom_navigation_bar.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showAppBar = true;
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
    _setSystemUIOverlayStyle();
    // جلب البيانات من Supabase
    context.read<HomeCubit>().loadHomeData(); 
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      final currentOffset = _scrollController.offset;
      
      if (currentOffset > _lastScrollOffset && currentOffset > 50 && _showAppBar) {
        setState(() => _showAppBar = false);
      } 
      else if (currentOffset < _lastScrollOffset && !_showAppBar) {
        setState(() => _showAppBar = true);
      }
      
      _lastScrollOffset = currentOffset;
    });
  }

  void _setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _dismissKeyboard() {
    _searchFocusNode.unfocus();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // الجزء العلوي الثابت
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              color: AppColors.background,
              padding: EdgeInsets.only(top: _showAppBar ? 0 : statusBarHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRect(
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      alignment: Alignment.topCenter,
                      heightFactor: _showAppBar ? 1.0 : 0.0,
                      child: HomeAppBar(showShadow: !_showAppBar),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: SearchBarWidget(
                      focusNode: _searchFocusNode,
                    ),
                  ),
                ],
              ),
            ),
            // المحتوى القابل للسكرول
            Expanded(
              child: GestureDetector(
                onTap: _dismissKeyboard,
                behavior: HitTestBehavior.opaque,
                child: AnimatedScreen(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      
                      if (state is HomeError) {
                        return Center(
                          child: Text(state.message),
                        );
                      }
                      
                      if (state is HomeLoaded) {
                        return SingleChildScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(12.h),
                              SpecialtiesSection(specialties: state.specialties),
                              Gap(24.h),
                              TopDoctorsSection(doctors: state.Doctors,),
                              Gap(24.h),
                              ClinicsSection(),
                              Gap(24.h),
                              RecentBookingsSection(),
                              Gap(24.h),
                              UpcomingAppointmentsSection(),
                              Gap(100.h),
                            ],
                          ),
                        );
                      }
                      
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}