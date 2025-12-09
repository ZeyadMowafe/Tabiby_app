import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tabiby/core/theming/styles.dart';


class DoctorImageAndText extends StatelessWidget {
  const DoctorImageAndText({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset('assets/svgs/tabiby_logo_2.svg', 
        height: 600.h,
        ),

        Positioned(
          bottom:30.h,
          left: 0,
          right: 0,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal:10.h ),
            child: Text(
              'أفضل تطبيق لحجز الأطباء\nنهتم بصحتك',
              textAlign: TextAlign.center,
              style: TextStyles.font24BlueBold.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}