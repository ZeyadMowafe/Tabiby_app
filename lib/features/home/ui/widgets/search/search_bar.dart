import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/colors.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Stack(
        children: [
          // Glow effect background
          Container(
            height: 60.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.headerPrimary.withOpacity(0.3),
                  blurRadius: 40.r,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.headerSecondary.withOpacity(0.2),
                  blurRadius: 60.r,
                  spreadRadius: 10,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
          ),
          // Main search container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: _buildSearchDecoration(),
            child: Row(
              children: [
                _buildSearchIcon(),
                Gap(16.w),
                Expanded(child: _buildTextField()),
                Gap(12.w),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildSearchDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          Colors.white.withOpacity(0.95),
        ],
      ),
      borderRadius: BorderRadius.circular(28.r),
      border: Border.all(
        color: AppColors.headerPrimary.withOpacity(0.1),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.9),
          blurRadius: 10.r,
          offset: const Offset(-5, -5),
        ),
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10.r,
          offset: const Offset(5, 5),
        ),
      ],
    );
  }

  Widget _buildSearchIcon() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.headerPrimary.withOpacity(0.15),
            AppColors.headerSecondary.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Icon(
        Icons.search_rounded,
        color: AppColors.headerPrimary,
        size: 24,
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search doctors, specialties...',
        hintStyle: TextStyle(
          color: Colors.grey.withOpacity(0.5),
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      style: TextStyle(
        color: Colors.black87,
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }


}