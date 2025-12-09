import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';
import 'package:tabiby/features/home/data/model/specialties_data.dart';
import 'package:tabiby/features/home/ui/widgets/specialty_card.dart';

class SpecialtiesFullScreen extends StatelessWidget {
  const SpecialtiesFullScreen({
    super.key,
    this.showBackButton = false, // parameter جديد
  });

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.backgroundGray,
        appBar: AppBar(
          backgroundColor: ColorsManager.white,
          elevation: 0,
          centerTitle: true,
          title: Text('التخصصات', style: TextStyles.font20PrimaryDarkBold),
          leading: showBackButton
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: ColorsManager.moreDarkBlue,
                    size: 20.sp,
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              : null, // لو من Bottom Nav مش هيظهر زرار رجوع
          automaticallyImplyLeading: showBackButton,
        ),
        body: Padding(
          padding: EdgeInsets.all(24.w),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.85,
            ),
            itemCount: SpecialtiesData.specialties.length,
            itemBuilder: (context, index) {
              final specialty = SpecialtiesData.specialties[index];
              return SpecialtyCard(
                icon: specialty.icon,
                title: specialty.title,
                color: specialty.color,
              );
            },
          ),
        ),
      ),
    );
  }
}